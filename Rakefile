require_relative 'lib/models/modou/store'

desc 'download apps as described in app-links.yml'
task :download_apps do
  require "yaml"

  YAML.load_file('app-links.yml')['github'].each do |app|
    require "octokit"
    require "dotenv"
    Dotenv.load

    if ENV['GITHUB_CLIENT_ID'] && ENV['GITHUB_CLIENT_SECRET']
      client = Octokit::Client.new \
        :client_id     => ENV['GITHUB_CLIENT_ID'],
        :client_secret => ENV['GITHUB_CLIENT_SECRET']
    else
      client = Octokit
    end

    latest_release = client.releases(app).first
    asset = latest_release.assets.first

    if File.exists?("tmp/cache/apps/#{asset.name}")
      puts "#{asset.name} is already downloaded."
    else
      puts "#{asset.name}, #{asset.browser_download_url}"
      system(ENV, "wget #{asset.browser_download_url} -O tmp/cache/apps/#{asset.name}")
    end
  end
end

desc 'copy and rename downloaded apps from tmp/cache/apps to data/apps'
task :release_apps do
  require "yaml"
  Dir['tmp/cache/apps/*'].each do |app_file|
    if manifest_hash = manifest_hash_for_file(app_file)
      # 0: none, 1: stable, 2: dev
      channel = 0

      # Stable
      yml_file = Dir['data/stable/*.yml'].select do |file|
        YAML.load_file(file)['package_id'] == manifest_hash['package_id']
      end.first

      if yml_file
        channel = 1
      else
        # Dev
        yml_file = Dir['data/dev/*.yml'].select do |file|
          YAML.load_file(file)['package_id'] == manifest_hash['package_id']
        end.first
        if yml_file
          channel = 2
        end
      end

      if channel != 0
        app_info = YAML.load_file(yml_file)
        `cp #{app_file} data/apps/#{app_info['name']}-#{app_info['version']}.mpk`
        tmp_folder = tmp_folder_for_app_name(app_name_for_app_file(app_file))
        require "pathname"
        icon_path = Pathname.new(tmp_folder).join(manifest_hash['icon'])

        if File.exists?(icon_path)
          `cp #{icon_path} #{icon_path_for_app(app_info)}`
        end
      end

    else
      puts "manifest.json not found for #{app_file}"
    end
  end
end

def icon_path_for_app(app_hash)
  "data/icons/#{app_hash['name']}-#{app_hash['version']}.png"
end

def app_name_for_app_file(app_file)
  app_file.split('/').last.gsub('.mpk', '').gsub('.tar.gz', '')
end

def tmp_folder_for_app_name(app_name)
  "tmp/app_folder/#{app_name}"
end

def manifest_hash_for_file(app_file)
  app_name = app_name_for_app_file(app_file)
  tmp_folder = tmp_folder_for_app_name(app_name)

  `mkdir -p #{tmp_folder}`

  `tar xzf #{app_file} -C #{tmp_folder}`

  if File.exists?("#{tmp_folder}/manifest.json")
    require "json"

    JSON(File.read("#{tmp_folder}/manifest.json"))
  end
end

desc 'generate meta info for app store from downloaded apps'
task :gen_meta do
  require "yaml"
  require 'digest'
  require 'securerandom'

  Dir['tmp/cache/apps/*'].each do |app_file|

    if manifest_hash = manifest_hash_for_file(app_file)
      # 0: none, 1: stable, 2: dev
      channel = 0

      # Stable
      yml_file = Dir["data/stable/*.yml"].select do |file|
        YAML.load_file(file)['package_id'] == manifest_hash['package_id']
      end.first

      if yml_file
        channel = 1
      else
        # Dev
        yml_file = Dir["data/dev/*.yml"].select do |file|
          YAML.load_file(file)['package_id'] == manifest_hash['package_id']
        end.first
        if yml_file
          channel = 2
        end
      end

      # defaults release to Stable
      if channel == 0
        app_info = merge_manifest_hash({}, manifest_hash)
        app_info['id'] = SecureRandom.uuid
        yml_file = "data/stable/#{manifest_hash['name']}.yml"
      else
        # already has definition, update it
        app_info = merge_manifest_hash(YAML.load_file(yml_file), manifest_hash)
      end

      app_info['size'] = File.size(app_file)
      app_info['md5_sum'] = Digest::MD5.file(app_file).hexdigest

      if YAML.load_file(yml_file) != app_info
        puts "updating #{yml_file}"

        app_info['available'] = true

        require "time"
        app_info['updated_at'] = Time.now.utc.iso8601

        File.write(yml_file, app_info.to_yaml)
      end
    else
      puts "manifest.json not found for #{app_file}"
    end
  end
end

def merge_manifest_hash(app_store_hash, manifest_hash)
  %w{ package_id author homepage version release_date icon description }.each do |spec|
    app_store_hash[spec] = manifest_hash[spec]
  end

  spec_mapping = {
    display_name:       'name',
    email:              'author_mail',
    install_location:   'location',
    instructions:       'instruction',
    require_os_version: 'os_version'
  }

  spec_mapping.each do |key, value|
    app_store_hash[key.to_s] = manifest_hash[value]
  end

  app_store_hash
end

desc 'push packages and icons to qiniu'
task :push_to_qiniu do
  require "dotenv"
  Dotenv.load

  `qboxrsctl login #{ENV['QINIU_ACCESS_KEY']} #{ENV['QINIU_SECRET_KEY']}`

  # push mpk
  Dir['data/apps/*.mpk'].each do |file|
    key = file[5..-1]
    `qboxrsctl put #{ENV['QINIU_BUCKET']} #{key} #{file}`
    puts "#{file} pushed to http://#{ENV['QINIU_BUCKET']}.qiniudn.com/#{key}"
  end

  # push icons
  Dir['data/icons/*.png'].each do |file|
    key = file[5..-1]
    `qboxrsctl put #{ENV['QINIU_BUCKET']} #{key} #{file}`
    puts "#{file} pushed to http://#{ENV['QINIU_BUCKET']}.qiniudn.com/#{key}"
  end
end

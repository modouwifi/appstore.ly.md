require_relative 'lib/models/modou/store'

desc 'download apps as described in app-links.yml'
task :download_apps do
  require "yaml"

  YAML.load_file('app-links.yml')['github'].each do |app|
    require "octokit"

    latest_release = Octokit.releases(app).first
    asset = latest_release.assets.first

    if File.exists?("tmp/cache/apps/#{asset.name}")
      puts "#{asset.name} is already downloaded."
    else
      system(ENV, "wget #{asset.browser_download_url} -O tmp/cache/apps/#{asset.name}")
    end
  end
end

desc 'copy and rename downloaded apps from tmp/cache/apps to data/apps'
task :release_apps do
  Dir['tmp/cache/apps/*'].each do |app_file|
    if manifest_hash = manifest_hash_for_file(app_file)
      require "yaml"

      yml_file = Dir['data/*.yml'].select do |file|
        YAML.load_file(file)['package_id'] == manifest_hash['package_id']
      end.first

      if yml_file
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
  Dir['tmp/cache/apps/*'].each do |app_file|
    require "yaml"

    if manifest_hash = manifest_hash_for_file(app_file)

      yml_file = Dir['data/*.yml'].select do |file|
        YAML.load_file(file)['package_id'] == manifest_hash['package_id']
      end.first

      if yml_file
        # already has definition, update it
        app_info = merge_manifest_hash(YAML.load_file(yml_file), manifest_hash)
      else
        # new app, create it
        app_info = merge_manifest_hash({}, manifest_hash)
        yml_file = "data/#{manifest_hash['name']}.yml"
      end

      app_info['size'] = File.size(app_file)
      app_info['md5_sum'] = Digest::MD5.file(app_file).hexdigest

      if YAML.load_file(yml_file) != app_info
        puts "updating #{yml_file}"

        app_info['available'] = true
        app_info['updated_at'] = Time.now

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

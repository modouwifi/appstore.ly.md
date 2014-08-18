require_relative 'lib/models/modou/store'

desc 'download apps as described in app-links.yml'
task :download_apps do
  require "yaml"

  YAML.load_file('app-links.yml')['github'].each do |app|
    require "octokit"

    latest_release = Octokit.releases(app).first
    asset = latest_release.assets.first

    system(ENV, "wget #{asset.browser_download_url} -c -O tmp/cache/apps/#{asset.name}")
  end
end

desc 'move and rename downloaded apps from tmp/cache/apps to data/apps'
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
      end
    else
      puts "manifest.json not found for #{app_file}"
    end
  end
end

def manifest_hash_for_file(app_file)
  app_name = app_file.split('/').last.gsub('.mpk', '').gsub('.tar.gz', '')
  tmp_folder = "tmp/app_folder/#{app_name}"

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
        hash = merge_manifest_hash(YAML.load_file(yml_file), manifest_hash)
      else
        # new app, create it
        hash = merge_manifest_hash({}, manifest_hash)
        yml_file = "data/#{manifest_hash['name']}.yml"
      end

      hash['size'] = File.size(app_file)

      File.write(yml_file, hash.to_yaml)
    else
      puts "manifest.json not found for #{app_file}"
    end
  end
end

def merge_manifest_hash(app_store_hash, manifest_hash)
  app_store_hash['package_id'] = manifest_hash['package_id']
  app_store_hash['display_name'] = manifest_hash['name']
  app_store_hash['author'] = manifest_hash['author']
  app_store_hash['email'] = manifest_hash['author_mail']
  app_store_hash['homepage'] = manifest_hash['homepage']
  app_store_hash['version'] = manifest_hash['version']
  app_store_hash['release_date'] = manifest_hash['release_date']
  app_store_hash['icon'] = manifest_hash['icon']
  app_store_hash['install_location'] = manifest_hash['location']
  app_store_hash['display_name'] = manifest_hash['name']
  app_store_hash['description'] = manifest_hash['description']
  app_store_hash['instructions'] = manifest_hash['instruction']
  app_store_hash['require_os_version'] = manifest_hash['os_version']

  app_store_hash
end

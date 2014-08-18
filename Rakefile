require_relative 'lib/models/modou/store'

desc 'cache apps to data/apps folder'
task :cache_apps do
  Modou::Store.all_apps.each do |app|
    system(ENV, "wget #{app.url} -c -O data/apps/#{app.fullname}")
  end
end

desc 'download apps as described in app-links.yml'
task :download_apps do
  require "yaml"

  YAML.load_file('app-links.yml').each do |link|
    system(ENV, "wget #{link} -c -O data/apps/#{link.split('/').last}")
  end
end

require_relative 'lib/models/modou/store'

desc 'cache apps to data/apps folder'
task :cache_apps do
  Modou::Store.all_apps.each do |app|
    `wget #{app.url} -c -O data/apps/#{app.fullname}`
  end
end

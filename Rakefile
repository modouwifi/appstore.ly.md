require_relative 'lib/models/modou/store'

desc 'download apps as described in app-links.yml'
task :download_apps do
  require "yaml"

  YAML.load_file('app-links.yml')['github'].each do |app|
    require "octokit"

    latest_release = Octokit.releases(app).first
    asset = latest_release.assets.first

    system(ENV, "wget #{asset.browser_download_url} -c -O data/apps/#{asset.name}")
  end
end

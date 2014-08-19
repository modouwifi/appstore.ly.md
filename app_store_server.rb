require "sinatra"
require "sinatra/json"

require File.expand_path("../lib/models/modou/store", __FILE__)

class AppStoreServer < Sinatra::Application
  configure do
    require 'newrelic_rpm'
  end

  before do
    headers 'Access-Control-Allow-Origin' => '*'
  end

  get '/apps' do
    json Modou::Store.all_apps.map(&:to_hash)
  end

  get '/apps/:app_id' do
    filename = File.expand_path("../data/apps/#{params[:app_id]}", __FILE__)

    if File.exists?(filename)
      send_file filename, filename: filename
    else
      json Modou::Store.app(params[:app_id]).to_hash
    end
  end

  get '/apps/:app_id/download' do
    app = Modou::Store.app(params[:app_id])

    # warning: possible security loophole here
    send_file File.expand_path("../data/apps/#{app.fullname}", __FILE__), filename: app.fullname
  end

  get '/apps/:app_id/icon' do
    app = Modou::Store.app(params[:app_id])

    # warning: possible security loophole here
    send_file File.expand_path("../data/icons/#{app.icon_name}", __FILE__), filename: app.icon_name, disposition: 'inline'
  end

  get '/icons/:app_id' do
    filename = File.expand_path("../data/icons/#{params[:app_id]}", __FILE__)

    if File.exists?(filename)
      icon_name = params[:app_id]
    else
      app = Modou::Store.app(params[:app_id])
      if app
        icon_name = app.icon_name

        filename = File.expand_path("../data/icons/#{icon_name}", __FILE__)
      else
        status 404
      end
    end

    send_file filename, filename: icon_name, disposition: 'inline'
  end
end

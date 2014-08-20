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

  # GET /apps                      => list all apps info, json format
  get '/apps' do
    json Modou::Store.all_apps.map(&:to_hash)
  end

  # GET /apps/hdns                 => hdns app info, json format
  # GET /apps/hdns-0.4.4.mpk       => hdns mpk download
  get '/apps/:app_id' do
    filename = File.expand_path("../data/apps/#{params[:app_id]}", __FILE__)

    if File.exists?(filename)
      send_file filename, filename: filename
    else
      json Modou::Store.app(params[:app_id]).to_hash
    end
  end

  # GET /apps/hdns/download        => hdns mpk download
  get '/apps/:app_id/download' do
    app = Modou::Store.app(params[:app_id])

    # warning: possible security loophole here
    send_file File.expand_path("../data/apps/#{app.fullname}", __FILE__), filename: app.fullname
  end

  # GET /apps/hdns/icon            => hdns icon download
  get '/apps/:app_id/icon' do
    app = Modou::Store.app(params[:app_id])

    # warning: possible security loophole here
    send_file File.expand_path("../data/icons/#{app.icon_name}", __FILE__), filename: app.icon_name, disposition: 'inline'
  end

  # GET /icons/hdns                => hdns icon download
  # GET /icons/hdns-0.4.4.png      => hdns icon download
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

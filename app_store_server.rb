require "sinatra"
require "sinatra/json"

require_relative "lib/models/modou/store"

class AppStoreServer < Sinatra::Application
  configure do
    require 'newrelic_rpm'

    require "qiniu"

    Qiniu.establish_connection! access_key: ENV['QINIU_ACCESS_KEY'], secret_key: ENV['QINIU_SECRET_KEY']
  end

  before do
    headers 'Access-Control-Allow-Origin' => '*'
  end

  helpers do
    def send_app_file(app_name)
      primitive_url = "http://#{ENV['QINIU_BUCKET']}.qiniudn.com/apps/#{app_name}"

      redirect Qiniu::Auth.authorize_download_url(primitive_url)
    end
  end

  # GET /apps                               => list all apps info, json format
  # GET /apps?os_version=OS_VERSION         => same above, with app.require_os_version <= OS_VERSION
  # GET /apps?install_location=LOCATION     => same above, with app.install_location == LOCATION
  #
  # params can be combined, e.g. GET /apps?install_location=internal&os_version=0.6.1
  get '/apps' do
    unless %w{ internal external }.include?(params[:install_location])
      params[:install_location] = nil
    end

    json Modou::Store.apps(params).map(&:to_hash)
  end

  # GET /unavailable_apps                   => list all apps info, json format
  get '/unavailable_apps' do
    json Modou::Store.unavailable_apps.map(&:to_hash)
  end

  # GET /apps/hdns                 => hdns app info, json format
  # GET /apps/com.modouwifi.hdns   => hdns app info, json format
  # GET /apps/hdns-0.4.4.mpk       => hdns mpk download
  get '/apps/:app_id' do
    filepath = File.expand_path("../data/apps/#{params[:app_id]}", __FILE__)

    if File.exists?(filepath)
      send_app_file params[:app_id]
    else
      begin
        json Modou::Store.app(params[:app_id]).to_hash
      rescue Exception => e
        status 404
      end
    end
  end

  # GET /apps/hdns/download                 => hdns mpk download
  # GET /apps/com.modouwifi.hdns/download   => hdns mpk download
  get '/apps/:app_id/download' do
    app = Modou::Store.app(params[:app_id])

    if app
      filepath = File.expand_path("../data/apps/#{app.fullname}", __FILE__)

      send_app_file(app.fullname)
    else
      status 404
    end
  end

  # GET /apps/hdns/icon                     => hdns icon download
  # GET /apps/com.modouwifi.hdns/icon       => hdns icon download
  get '/apps/:app_id/icon' do
    app = Modou::Store.app(params[:app_id])

    if app
      filepath = File.expand_path("../data/icons/#{app.icon_name}", __FILE__)

      send_file filepath, filename: app.icon_name, disposition: 'inline'
    else
      status 404
    end
  end

  # GET /icons/hdns                         => hdns icon download
  # GET /icons/com.modouwifi.hdns           => hdns icon download
  # GET /icons/hdns-0.4.4.png               => hdns icon download
  get '/icons/:app_id' do
    filepath = File.expand_path("../data/icons/#{params[:app_id]}", __FILE__)

    if File.exists?(filepath)
      icon_name = params[:app_id]
    else
      if app = Modou::Store.app(params[:app_id])
        icon_name = app.icon_name

        filepath = File.expand_path("../data/icons/#{icon_name}", __FILE__)
      end
    end

    # implicit 404 if file not found
    send_file filepath, filename: icon_name, disposition: 'inline'
  end
end

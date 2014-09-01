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
    def send_qiniu_file(filepath)
      primitive_url = "http://#{ENV['QINIU_BUCKET']}.qiniudn.com/#{filepath}"

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

  # GET /apps/unavailable                   => list all apps info, json format
  get '/apps/unavailable' do
    json Modou::Store.unavailable_apps.map(&:to_hash)
  end

  # GET /apps/upgrades?apps[]=hdns-0.4.1&apps[]=welcome-page-0.1
  get '/apps/upgrades' do
    json Modou::Store.available_upgrades(params[:apps]).map(&:to_hash)
  end

  # GET /apps/hdns                                  => hdns app info, json format
  # GET /apps/com.modouwifi.hdns                    => hdns app info, json format
  # GET /apps/452a1fea-66d2-4239-b450-3e4e05ac96db  => hdns app info, json format
  # GET /apps/hdns-0.4.4.mpk                        => hdns mpk download
  get '/apps/:app_id' do
    if params[:app_id] =~ /^(.+)-([^-]+)\.mpk$/
      if Modou::Store.app($1) && Modou::Store.app($1).version == $2
        send_qiniu_file "apps/#{params[:app_id]}"
      else
        status 404
      end
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
      send_qiniu_file "apps/#{app.fullname}"
    else
      status 404
    end
  end

  # GET /apps/hdns/icon                     => hdns icon download
  # GET /apps/com.modouwifi.hdns/icon       => hdns icon download
  get '/apps/:app_id/icon' do
    app = Modou::Store.app(params[:app_id])

    if app
      send_qiniu_file "icons/#{app.icon_name}"
    else
      status 404
    end
  end

  # GET /apps/hdns/versions                 => all version info of hdns, json format
  # GET /apps/com.modouwifi.hdns/versions   => all version info of hdns, json format
  get '/apps/:app_id/versions' do
    raise 'not implemented yet'
  end

  # GET /icons/hdns                                  => hdns icon download
  # GET /icons/com.modouwifi.hdns                    => hdns icon download
  # GET /icons/452a1fea-66d2-4239-b450-3e4e05ac96db  => hdns icon download
  # GET /icons/hdns-0.4.4.png                        => hdns icon download
  get '/icons/:app_id' do
    if params[:app_id] =~ /^(.+)-([^-]+)\.png$/
      if Modou::Store.app($1) && Modou::Store.app($1).version == $2
        icon_name = params[:app_id]
      end
    else
      if app = Modou::Store.app(params[:app_id])
        icon_name = app.icon_name
      end
    end

    if icon_name
      send_qiniu_file "icons/#{icon_name}"
    else
      status 404
    end
  end
end

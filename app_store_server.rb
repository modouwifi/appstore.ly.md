require "sinatra"
require "sinatra/json"

require File.expand_path("../lib/models/modou/store", __FILE__)

class AppStoreServer < Sinatra::Application
  configure do
    set :json_content_type, "application/json;charset=utf-8"
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
end

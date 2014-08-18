require "sinatra"
require "sinatra/json"

require File.expand_path("../lib/models/modou/store", __FILE__)

class AppStoreServer < Sinatra::Application
  get '/list' do
    json Modou::Store.all_apps.map(&:to_hash)
  end

  get '/apps/:app_id' do
    json Modou::Store.app(params[:app_id]).to_hash
  end

  get '/apps/:app_id/download' do
    app = Modou::Store.app(params[:app_id])

    # warning: possible security loophole here
    send_file File.expand_path("../data/apps/#{app.fullname}", __FILE__), filename: app.fullname
  end
end

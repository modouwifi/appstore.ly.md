require "sinatra"
require "sinatra/json"

require File.expand_path("../lib/models/modou/application", __FILE__)

get '/list' do
  apps = []

  Dir[File.expand_path('../data/*.yml',  __FILE__)].each do |yml_file|
    apps << Modou::Application.create_from_yml(File.read(yml_file))
  end

  json apps.map(&:to_hash)
end

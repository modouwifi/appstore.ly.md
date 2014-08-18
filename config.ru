require File.expand_path("../app_store_server.rb", __FILE__)

run Rack::Cascade.new [AppStoreServer]

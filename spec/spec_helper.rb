require "simplecov"

if ENV['SIMPLECOV'] == 'true'
  SimpleCov.start do
    add_filter '/spec/'
  end
else
  require "coveralls"

  Coveralls.wear! do
    add_filter '/spec/'
  end
end


require File.expand_path("../../lib/models/modou/semantic_version.rb", __FILE__)
require File.expand_path("../../lib/models/modou/application.rb", __FILE__)
require File.expand_path("../../lib/models/modou/store.rb", __FILE__)

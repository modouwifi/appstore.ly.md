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

class Modou::Store
  def self.all_apps
    [].tap do |apps|
      Dir[File.expand_path('../fixtures/data/*.yml',  __FILE__)].each do |yml_file|
        apps << Modou::Application.create_from_yml(File.read(yml_file))
      end
    end
  end
end

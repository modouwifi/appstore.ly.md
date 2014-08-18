require_relative 'application'

module Modou
  class Store
    class << self
      def all_apps
        [].tap do |apps|
          Dir[File.expand_path('../../../../data/*.yml',  __FILE__)].each do |yml_file|
            apps << Modou::Application.create_from_yml(File.read(yml_file))
          end
        end
      end

      # return app with app-name
      def app(name)
        all_apps.select { |app| app.name == name }.first
      end
    end
  end
end

require_relative 'semantic_version'
require_relative 'application'

module Modou
  class Store
    class << self
      def all_apps
        [].tap do |apps|
          Dir[File.expand_path('../../../../data/*.yml',  __FILE__)].each do |yml_file|
            apps << Modou::Application.create_from_yml(File.read(yml_file))
          end
        end.sort_by(&:updated_at).reverse
      end

      # return apps according to given criteria
      def apps(criteria = {})
        all_apps.tap do |apps|
          if criteria[:os_version]
            apps.reject! { |app| SemanticVersion.new(app.require_os_version) > criteria[:os_version] }
          end
          if criteria[:install_location]
            apps.reject! { |app| app.cannot_install_at(criteria[:install_location]) }
          end
        end
      end

      # return app with app-name
      def app(name_or_package_id)
        all_apps.select do |app|
          app.name == name_or_package_id || app.package_id == name_or_package_id
        end.first
      end
    end
  end
end

require_relative 'semantic_version'
require_relative 'application'

module Modou
  class Store
    class << self
      # all available apps
      def all_apps
        [].tap do |apps|
          Dir[File.expand_path('../../../../data/*.yml',  __FILE__)].each do |yml_file|
            apps << Modou::Application.create_from_yml(File.read(yml_file))
          end
        end.select(&:available?).sort_by(&:updated_at).reverse
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

      def unavailable_apps
        [].tap do |apps|
          Dir[File.expand_path('../../../../data/*.yml',  __FILE__)].each do |yml_file|
            apps << Modou::Application.create_from_yml(File.read(yml_file))
          end
        end.select(&:unavailable?).sort_by(&:updated_at).reverse
      end

      def available_upgrades(app_full_names)
        app_full_names.map do |app_full_name|
          app_full_name =~ /^(.+)-([^-]+)$/
          app_name, app_version = $1, $2
          if app(app_name) && SemanticVersion.new(app(app_name).version) > app_version
            app(app_name)
          else
            nil
          end
        end.compact
      end

      # return app with app-name
      def app(id_or_name_or_package_id)
        all_apps.select do |app|
          [app.name, app.id, app.package_id].include?(id_or_name_or_package_id)
        end.first
      end
    end
  end
end

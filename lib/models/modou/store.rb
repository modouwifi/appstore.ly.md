require_relative 'application'

class Array
  def filter_with_criteria(criteria)
    if criteria[:os_version]
      reject! { |app| Modou::SemanticVersion.new(app.require_os_version) > criteria[:os_version] }
    end
    if criteria[:install_location]
      reject! { |app| app.cannot_install_at(criteria[:install_location]) }
    end
    self
  end
end

module Modou
  class Store
    class << self

      attr_accessor :apps_data

      def find(router_system_info = {:track => 'stable'})
        @apps_data = apps_by_stable
        if router_system_info[:track] != 'stable'
          @apps_data = apps.concat(apps_by_dev)
        end
        self
      end

      # For Stable Router
      def apps_by_stable
        [].tap do |stable_apps|
          Dir[File.expand_path('../../../../data/stable/*.yml',  __FILE__)].each do |yml_file|
            stable_apps << Modou::Application.create_from_yml(File.read(yml_file))
          end
        end
      end

      # For Development Router
      def apps_by_dev
        [].tap do |dev_apps|
          # For Stable Router
          Dir[File.expand_path('../../../../data/dev/*.yml',  __FILE__)].each do |yml_file|
            dev_apps << Modou::Application.create_from_yml(File.read(yml_file))
          end
        end
      end

      # all apps
      def all_apps
        @apps_data
      end

      # all available apps
      def all_available_apps
        all_apps.select(&:available?).sort_by(&:updated_at).reverse
      end

      # return apps according to given criteria
      def apps(criteria = {})
        all_available_apps.filter_with_criteria(criteria)
      end

      def unavailable_apps
        all_apps.select(&:unavailable?).sort_by(&:updated_at).reverse
      end

      def available_upgrades(app_full_names, criteria = {})
        app_full_names.map do |app_full_name|

          app_full_name =~ /^(.+)-([^-]+)$/
          app_name, app_version = $1, $2

          if app(app_name) && app(app_name).semantic_version > app_version
            app(app_name)
          else
            nil
          end
        end.compact.filter_with_criteria(criteria)
      end

      # return app with app-name
      def app(id_or_name_or_package_id)
        all_available_apps.find do |app|
          [app.name, app.id, app.package_id].include?(id_or_name_or_package_id)
        end
      end
    end
  end
end

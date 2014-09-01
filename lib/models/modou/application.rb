module Modou
  class Application
    attr_accessor :name
    attr_accessor :url
    attr_accessor :version
    attr_accessor :author
    attr_accessor :homepage
    attr_accessor :icon
    attr_accessor :description
    attr_accessor :email
    attr_accessor :package_id
    attr_accessor :md5_sum
    attr_accessor :size
    attr_accessor :release_date
    attr_accessor :instructions
    attr_accessor :require_os_version
    attr_accessor :install_location
    attr_accessor :display_name
    attr_accessor :updated_at
    attr_accessor :available
    attr_accessor :why_unavailable
    attr_accessor :tp_enabled
    attr_accessor :mobile_enabled
    attr_accessor :versions
    attr_accessor :latest_version
    attr_accessor :release_notes
    attr_accessor :id

    IVARS = %w{ name url version author homepage icon
      description email package_id md5_sum size release_date instructions
      require_os_version install_location display_name updated_at available id }.freeze

    def to_yml
      require "yaml"

      to_hash.to_yaml
    end

    def to_hash
      hash = Hash.new.tap do |hash|
        IVARS.map do |ivar|
          hash[ivar] = instance_variable_get("@#{ivar}")
        end
      end

      hash['url'] = "http://appstore.ly.md/apps/#{fullname}"
      hash['icon_url'] = icon_url

      hash['why_unavailable'] = self.why_unavailable if unavailable?

      hash
    end

    def fullname
      "#{name}-#{version}.mpk"
    end

    def icon_url
      "http://appstore.ly.md/icons/#{icon_name}"
    end

    def icon_name
      "#{name}-#{version}.png"
    end

    def can_install_at?(location)
      return true if self.install_location == 'both'

      self.install_location == location.to_s
    end

    def cannot_install_at(location)
      !can_install_at?(location)
    end

    def available?
      @available
    end

    def unavailable?
      !available?
    end

    def initialize
      yield self if block_given?
    end

    class << self
      def create_from_yml(yml_content)
        require "yaml"

        data = YAML.load(yml_content)

        new do |application|
          IVARS.each do |ivar|
            application.instance_variable_set("@#{ivar}", data[ivar])
          end
          application.why_unavailable = data['why_unavailable'] if application.unavailable?
        end
      end
    end
  end
end

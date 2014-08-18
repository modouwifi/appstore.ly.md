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

    IVARS = %w{ name url version author homepage icon
      description email package_id md5_sum size release_date instructions
      require_os_version install_location }.freeze

    def to_yml
      raise 'not implemented yet'
    end

    def to_hash
      hash = Hash.new.tap do |hash|
        IVARS.map do |ivar|
          hash[ivar] = instance_variable_get("@#{ivar}")
        end
      end

      hash['url'] = "http://appstore.ly.md/apps/#{fullname}"

      hash
    end

    def fullname
      "#{name}-#{version}.mpk"
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
        end
      end
    end
  end
end

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

    IVARS = %w{ name url version author homepage icon description email }.freeze

    def to_yml
      raise 'not implemented yet'
    end

    def to_hash
      hash = Hash.new.tap do |hash|
        IVARS.map do |ivar|
          hash[ivar] = instance_variable_get("@#{ivar}")
        end
      end

      hash
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

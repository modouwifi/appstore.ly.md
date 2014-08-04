module Modou
  class Application
    attr_accessor :name
    attr_accessor :url
    attr_accessor :version
    attr_accessor :author
    attr_accessor :homepage

    def to_yml
      raise 'not implemented yet'
    end

    def to_hash
      hash = Hash.new.tap do |hash|
        %w{name url version author homepage}.map do |ivar|
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
          application.name = data['name']
          application.url = data['url']
          application.version = data['version']
          application.author = data['author']
          application.homepage = data['homepage']
        end
      end
    end
  end
end

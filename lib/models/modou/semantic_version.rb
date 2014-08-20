module Modou
  class SemanticVersion
    attr_accessor :major, :minor, :patch

    include Comparable

    def initialize(version_string)
      version_string ||= '0.0.0'

      @major, @minor, @patch = version_string.split('.').map(&:to_i)

      @major ||= 0
      @minor ||= 0
      @patch ||= 0
    end

    def <=>(another)
      return self.<=>(SemanticVersion.new(another)) if another.kind_of?(String)

      if @major == another.major
        if @minor == another.minor
          @patch <=> another.patch
        else
          @minor <=> another.minor
        end
      else
        @major <=> another.major
      end
    end
  end
end

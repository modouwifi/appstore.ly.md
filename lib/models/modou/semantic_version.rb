module Modou
  class SemanticVersion
    attr_accessor :major, :minor, :patch

    include Comparable

    def initialize(version_string)
      @major, @minor, @patch = version_string.split('.').map(&:to_i)
    end

    def <=>(another)
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

require "spec_helper"

module Modou
  describe SemanticVersion do
    def version(version_string)
      SemanticVersion.new(version_string)
    end

    it 'compares version' do
      version('0.6.12').should == version('0.6.12')
      version('0.6.13').should > version('0.6.12')
      version('0.7').should > version('0.6.12')
      version('0.7.0').should > version('0.6.12')
      version('1.0').should > version('0.6.12')
      version('0.6.13').should > version('0.6.2')
      version('0.1.5').should < version('0.1.333')
    end

    it 'compares to string as well' do
      version('0.6.12').should == '0.6.12'
      version('0.6.13').should > '0.6.12'
      version('0.1.5').should < '0.1.333'
    end

    it 'handle nil as well' do
      version(nil).should < '0.1.1'
    end

    it 'get major, minor and patch right' do
      version('0.7').major.should == 0
      version('0.7').minor.should == 7
      version('0.7').patch.should == 0
    end
  end
end

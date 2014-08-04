require "spec_helper"

module Modou
  describe Application do
    it { should respond_to :name }
    it { should respond_to :url }
    it { should respond_to :author }
    it { should respond_to :homepage }
    it { should respond_to :version }
  end
end

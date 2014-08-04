require "spec_helper"

module Modou
  describe Application do
    describe "instance methods" do
      it { should respond_to :name }
      it { should respond_to :url }
      it { should respond_to :author }
      it { should respond_to :homepage }
      it { should respond_to :version }
      it { should respond_to :to_yml }
      it { should respond_to :to_hash }
      it { should respond_to :icon }
      it { should respond_to :description }
    end

    describe "class methods" do
      subject { Application }
      it { should respond_to :create_from_yml }
    end
  end
end

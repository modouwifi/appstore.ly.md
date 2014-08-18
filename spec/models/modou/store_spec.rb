require "spec_helper"

module Modou
  describe Store do
    describe 'class methods' do
      subject { Store }
      it { should respond_to :all_apps }
      it { should respond_to :app }
    end
  end
end

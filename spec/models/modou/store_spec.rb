require "spec_helper"

module Modou
  describe Store do
    describe 'class methods' do
      subject { Store }
      it { should respond_to :all_apps }
      it { should respond_to :apps }
      it { should respond_to :app }

      describe '.app' do
        it 'has hdns' do
          Store.app('hdns').package_id.should == 'com.modouwifi.hdns'
        end

        it 'get app by package_id as well' do
          Store.app('com.modouwifi.hdns').name.should == 'hdns'
        end
      end
    end
  end
end

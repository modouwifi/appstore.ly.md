require "spec_helper"

module Modou
  describe Store do
    describe 'class methods' do
      subject { Store }
      it { should respond_to :all_apps }
      it { should respond_to :apps }
      it { should respond_to :app }
      it { should respond_to :unavailable_apps }
      it { should respond_to :available_upgrades }

      describe '.available_upgrades' do
        it 'gets available upgrades' do
          Store.available_upgrades(['hdns-0.0.1']).count.should == 1
        end
      end

      describe '.app' do
        it 'has hdns' do
          Store.app('hdns').package_id.should == 'com.modouwifi.hdns'
        end

        it 'get app by package_id as well' do
          Store.app('com.modouwifi.hdns').name.should == 'hdns'
        end

        it 'gets app by uuid' do
          Store.app('452a1fea-66d2-4239-b450-3e4e05ac96db').name.should == 'hdns'
          Store.app('b727179e-4143-4d60-8e88-7c24c81d1027').name.should == 'wps'
          Store.app('b727179e-4143-4d60-8e88-7c24c81d1027').icon_name.should == 'wps-0.4.png'
        end
      end

      describe '.apps' do
        let(:hdns) { Application.new.tap { |app| app.require_os_version = '0.1.1' } }
        let(:wps) { Application.new.tap { |app| app.require_os_version = '0.3.1' } }

        before do
          Store.stub(:all_apps).and_return([hdns, wps])
        end

        it 'filters apps' do
          Store.apps(os_version: '0.2').should == [hdns]
        end

        it 'return all apps if no criteria given' do
          Store.apps.should == [hdns, wps]
        end

        it 'return no apps if os_version is too low' do
          Store.apps(os_version: '0.1').should == []
        end
      end
    end
  end
end

require "spec_helper"

ENV['RACK_ENV'] = 'test'

require File.expand_path('../../app_store_server.rb', __FILE__)

require 'rspec'
require 'rack/test'

describe 'AppStoreServer' do
  include Rack::Test::Methods

  def app
    AppStoreServer
  end

  before :each do
    Qiniu::Auth.stub(:authorize_download_url) do |primitive_url|
      "#{primitive_url}?authorized=true"
    end
  end

  describe 'HTTP Cross-Site Attack Prevention' do
    before do
      ENV['CROSS_SITE_PREVENTION'] = "true"
    end

    it 'denies requests from bad origins' do
      get '/apps/hdns/download', {}, { 'HTTP_ORIGIN' => 'http://google.com' } do
        last_response.status.should == 403
      end
    end

    it 'allow requests from http://modouwifi.net' do
      get '/apps', {}, { 'HTTP_ORIGIN' => 'http://modouwifi.net' } do
        last_response.status.should == 200
      end
    end

    it 'allow requests from http://www.modouwifi.net' do
      get '/apps', {}, { 'HTTP_ORIGIN' => 'http://www.modouwifi.net' } do
        last_response.status.should == 200
      end
    end

    it 'disallow requests from http://modouwifi.net1' do
      get '/apps', {}, { 'HTTP_ORIGIN' => 'http://modouwifi.net1' } do
        last_response.status.should == 403
      end
    end

    it 'allow requests from http://192.168.18.1' do
      get '/apps', {}, { 'HTTP_ORIGIN' => 'http://192.168.18.1' } do
        last_response.status.should == 200
      end
    end

    it 'allow requests from http://192.168.19.1' do
      get '/apps', {}, { 'HTTP_ORIGIN' => 'http://192.168.19.1' } do
        last_response.status.should == 200
      end
    end

    it 'allow requests from http://127.0.0.1:3000' do
      get '/apps', {}, { 'HTTP_ORIGIN' => 'http://127.0.0.1:3000' } do
        last_response.status.should == 200
      end
    end

    it 'disallow requests from http://192.168.1' do
      get '/apps', {}, { 'HTTP_ORIGIN' => 'http://192.168.1' } do
        last_response.status.should == 403
      end
    end

    it 'disallow requests from http://192.168.1:3000' do
      get '/apps', {}, { 'HTTP_ORIGIN' => 'http://192.168.1:3000' } do
        last_response.status.should == 403
      end
    end
  end

  describe 'GET /apps' do
    it "gets a list of apps" do
      get '/apps' do
        expect(last_response).to be_ok

        JSON(last_response.body).count.should == Modou::Store.all_available_apps.count
      end
    end

    it "filter apps with os_version" do
      get '/apps?os_version=0.0.1' do
        expect(last_response).to be_ok

        JSON(last_response.body).count.should < Modou::Store.all_available_apps.count
      end
    end

    it 'filter apps with install_location' do
      get '/apps?install_location=external' do
        expect(last_response).to be_ok

        JSON(last_response.body).count.should < Modou::Store.all_available_apps.count
      end
    end

    it 'filter apps with track, stable' do
      get '/apps?track=stable' do
        expect(last_response).to be_ok

        JSON(last_response.body).count.should == Modou::Store.apps_by_stable.select(&:available?).sort_by(&:updated_at).count
      end
    end

    it 'filter apps with track, dev' do
      get '/apps?track=inter' do
        expect(last_response).to be_ok

        JSON(last_response.body).count.should == Modou::Store.find({:track => 'inter'}).all_available_apps.count
      end
    end
  end

  describe 'GET /apps/unavailble' do
    it 'gets unavailable apps' do
      get '/apps/unavailable' do
        last_response.status.should == 200
        JSON(last_response.body).count.should > 0
      end
    end
  end

  describe 'GET /apps/upgrades' do
    it 'gets available upgrades' do
      get '/apps/upgrades?apps[]=hdns-0.0.1' do
        last_response.status.should == 200
        JSON(last_response.body).count.should == 1
        JSON(last_response.body).first['name'].should == 'hdns'
      end
    end

    it 'gets available upgrades' do
      get '/apps/upgrades?apps[]=hdns-0.0.1&apps[]=wps-0.0.1' do
        last_response.status.should == 200
        JSON(last_response.body).count.should == 2
      end
    end

    it 'retrieves empty list if version unavailable' do
      get '/apps/upgrades?apps[]=hdns-99.0.1' do
        last_response.status.should == 200
        JSON(last_response.body).count.should == 0
      end
    end

    it 'retrieves empty list if app not exist' do
      get '/apps/upgrades?apps[]=blablabla-0.0.1' do
        last_response.status.should == 200
        JSON(last_response.body).count.should == 0
      end
    end

    it 'get available upgrades filtered with install_location' do
      get '/apps/upgrades?apps[]=hdns-0.0.1&apps[]=wps-0.0.1&install_location=external' do
        last_response.status.should == 200
        JSON(last_response.body).count.should == 1
        JSON(last_response.body).first['name'].should == 'wps'
      end
    end

    it 'get available upgrades filtered with os_version' do
      get '/apps/upgrades?apps[]=hdns-0.0.1&apps[]=wps-0.0.1&os_version=0.6.16' do
        last_response.status.should == 200
        JSON(last_response.body).count.should == 1
        JSON(last_response.body).first['name'].should == 'hdns'
      end
    end
  end

  describe 'GET /apps/:app_id' do
    it 'gets app info with app name' do
      get '/apps/hdns' do
        last_response.status.should == 200
        JSON(last_response.body)['name'].should == 'hdns'
        # JSON(last_response.body)['id'].length.should > 0
      end
    end

    it 'gets app info with app package_id' do
      get '/apps/com.modouwifi.hdns' do
        last_response.status.should == 200
        JSON(last_response.body)['name'].should == 'hdns'
      end
    end

    it 'gets app file with app file name' do
      get '/apps/hdns-0.4.4.mpk' do
        last_response.status.should == 302
        last_response.headers['Location'].should =~ /qiniudn\.com/
      end
    end

    it 'gets app info with uuid' do
      get '/apps/452a1fea-66d2-4239-b450-3e4e05ac96db' do
        last_response.status.should == 200
        JSON(last_response.body)['name'].should == 'hdns'
      end
    end

    it 'gets 404 if app not found' do
      get '/apps/wahahahahahaha' do
        last_response.status.should == 404
      end
    end

    it 'gets 404 if file not found' do
      get '/apps/hdns-0.0.1.mpk' do
        last_response.status.should == 404
      end

      get '/apps/blablabla-0.0.1.mpk' do
        last_response.status.should == 404
      end
    end
  end

  describe 'GET /apps/:app_id/download' do
    it 'gets app mpk with app name' do
      get '/apps/hdns/download' do
        last_response.status.should == 302
        last_response.headers['location'].should =~ /qiniudn\.com\/apps\/hdns/
      end
    end

    it 'gets app with app package_id as well' do
      get '/apps/com.modouwifi.hdns/download' do
        last_response.status.should == 302
        last_response.headers['location'].should =~ /qiniudn\.com\/apps\/hdns/
      end
    end

    it 'gets app with uuid' do
      get '/apps/452a1fea-66d2-4239-b450-3e4e05ac96db/download' do
        last_response.status.should == 302
        last_response.headers['location'].should =~ /qiniudn\.com\/apps\/hdns/
      end
    end

    it 'gets 404 if app not found' do
      get '/apps/some.random.stupid.app/download' do
        last_response.status.should == 404
      end
    end
  end

  describe 'GET /icons/:app_id' do
    it 'gets 404 if app not found' do
      get '/icons/blablabla' do
        last_response.status.should == 404
      end
    end

    it 'get 404 if file not found' do
      get '/icons/blablabla-0.0.1.png' do
        last_response.status.should == 404
      end
    end

    it 'get icon file with app name' do
      get '/icons/wps' do
        last_response.status.should == 302
        last_response.headers['Location'].should =~ /qiniudn\.com/
      end
    end

    it 'get icon file with package_id' do
      get '/icons/com.modouwifi.app-wps' do
        last_response.status.should == 302
        last_response.headers['Location'].should =~ /qiniudn\.com/
      end
    end

    it 'get icon file with file name' do
      get '/icons/wps-0.4.png' do
        last_response.status.should == 302
        last_response.headers['Location'].should =~ /qiniudn\.com/
      end
    end

    it 'gets icon file with uuid' do
      get '/icons/b727179e-4143-4d60-8e88-7c24c81d1027' do
        last_response.status.should == 302
        last_response.headers['location'].should =~ /qiniudn\.com/
      end
    end
  end
end

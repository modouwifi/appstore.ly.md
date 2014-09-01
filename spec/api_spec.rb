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

  describe 'GET /apps' do
    it "gets a list of apps" do
      get '/apps' do
        expect(last_response).to be_ok

        JSON(last_response.body).count.should == Modou::Store.all_apps.count
      end
    end

    it "filter apps with os_version" do
      get '/apps?os_version=0.0.1' do
        expect(last_response).to be_ok

        JSON(last_response.body).count.should < Modou::Store.all_apps.count
      end
    end

    it 'filter apps with install_location' do
      get '/apps?install_location=external' do
        expect(last_response).to be_ok

        JSON(last_response.body).count.should < Modou::Store.all_apps.count
      end
    end
  end

  describe 'GET /unavailable_apps' do
  end

  describe 'GET /apps/:app_id' do
    it 'gets app info with app name' do
      get '/apps/hdns' do
        last_response.status.should == 200
        JSON(last_response.body)['name'].should == 'hdns'
        JSON(last_response.body)['id'].length.should > 0
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
        last_response.headers['location'].should =~ /qiniudn.com\/apps\/hdns/
      end
    end

    it 'gets app with app package_id as well' do
      get '/apps/com.modouwifi.hdns/download' do
        last_response.status.should == 302
        last_response.headers['location'].should =~ /qiniudn.com\/apps\/hdns/
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
  end
end

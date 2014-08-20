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
      it { should respond_to :package_id }
      it { should respond_to :md5_sum }
      it { should respond_to :size }
      it { should respond_to :release_date }
      it { should respond_to :instructions }
      it { should respond_to :fullname }
      it { should respond_to :require_os_version }
      it { should respond_to :install_location }
      it { should respond_to :display_name }
      it { should respond_to :icon_url }
      it { should respond_to :updated_at }

      describe '#fullname' do
        it 'generates fullname' do
          app = Application.new
          app.name = 'hdns'
          app.version = '1.0'
          app.fullname.should == 'hdns-1.0.mpk'
        end
      end
    end

    describe "class methods" do
      subject { Application }
      it { should respond_to :create_from_yml }
    end
  end
end

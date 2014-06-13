require 'spec_helper'

module TinyMCE::Rails
  describe Engine do
    describe ".default_base" do
      it "generates a default path based on the asset prefix" do
        TinyMCE::Rails::Engine.default_base.should eq "/assets/tinymce"
      end

      it "ignores the asset prefix if missing" do
        Rails.application.config.assets.stub(:prefix).and_return nil
        TinyMCE::Rails::Engine.default_base.should eq "/tinymce"
      end

      it "includes the Rails relative_url_root if provided" do
        Rails.application.config.stub(:relative_url_root).and_return "/prefix"
        TinyMCE::Rails::Engine.default_base.should eq "/prefix/assets/tinymce"
      end
      
      it "includes the asset host if it is a string" do
        Rails.application.config.action_controller.stub(:asset_host).and_return "assets.example.com"
        TinyMCE::Rails::Engine.default_base.should eq "//assets.example.com/assets/tinymce"
      end
      
      it "interpolates the asset host if it is a string containing %d" do
        Rails.application.config.action_controller.stub(:asset_host).and_return "assets%d.example.com"
        TinyMCE::Rails::Engine.default_base.should eq "//assets0.example.com/assets/tinymce"
      end
      
      it "does not include the asset host if it is a callable" do
        Rails.application.config.action_controller.stub(:asset_host).and_return ->(request) { "assets.example.com" }
        TinyMCE::Rails::Engine.default_base.should eq "/assets/tinymce"
      end
    end
  end
end

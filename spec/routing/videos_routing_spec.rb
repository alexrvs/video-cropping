require "rails_helper"

RSpec.describe Api::V1::VideosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "api/v1/videos").to route_to("api/v1/videos#index")
    end

    it "routes to #create" do
      expect(:post => "api/v1/videos").to route_to("api/v1/videos#create")
    end

    it "routes to #reload via POST" do
      expect(:post => "api/v1/videos/5eb126cf16e32b6d38c9eb8c/reload").to route_to("api/v1/videos#reload", :id => "5eb126cf16e32b6d38c9eb8c")
    end
  end
end

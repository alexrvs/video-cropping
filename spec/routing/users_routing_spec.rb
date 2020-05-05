require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :routing do
  describe "routing" do

    it "routes to #create" do
      expect(:post => "api/v1/users").to route_to("api/v1/users#create")
    end
  end
end

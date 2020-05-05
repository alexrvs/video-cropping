require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    it "should create user" do
      post api_v1_users_path
      expect(response).to have_http_status(201)
    end
  end
end

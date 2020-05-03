require 'swagger_helper'

describe 'User API' do

  path '/api/v1/users' do

    post 'Creates a User' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :pet, in: :body, schema: {
          type: :object,
          properties: {
          },
          required: []
      }

      response('201', 'user created') {
        let(:user) {
          { id: "5ea5729516e32b6c3a5051b7",
            created_at: "2020-04-26 11:37:57 UTC",
            updated_at: "2020-04-26 11:37:57 UTC",
            access_token: "cbe76d8a6eab4a78bf9bd9cea0aa16c8"} }
        run_test!
      }

      response '422', 'invalid request' do
        let(:user) { 
          { id: "5ea5729516e32b6c3a5051b7",
            created_at: "2020-04-26 11:37:57 UTC",
            updated_at: "2020-04-26 11:37:57 UTC",
            access_token: " " } }
        run_test!
      end
    end
  end

end
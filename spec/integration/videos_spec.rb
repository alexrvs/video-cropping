# spec/integration/videos_spec.rb
require 'swagger_helper'

describe 'Video API' do

  path '/api/v1/videos' do
    post 'Uploads videos by authorized user' do
      tags 'Videos'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header, type: :string, default: 'Token 8b6a04aac0264bef89d99c3cc5fd8513'
      parameter name: :video, in: :fromData, schema: {
        type: :object,
        properties: {
          start_time_trim: { type: :integer, example: 10 },
          end_time_trim: { type: :integer, example: 50 }
        },
        required: %w[start_time_trim end_time_trim]
      }
      parameter name: :input_video, in: :formData, type: :file, required: true

      response '401', :unauthorized do
        let(:Authorization){ '' }
        let(:video) {
          {
            start_time_trim: 10,
            end_time_trim: 50,
            input_video: Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/videos/nature.mp4"))
          }
        }
        run_test!
      end

      response '201', :created do
        let!(:user) { FactoryBot.create(:user) }
        let(:Authorization) { 'Token ' + user.access_token }
        let(:video) { { start_time_trim: 10, end_time_trim: 50, input_video: Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/videos/nature.mp4")) } }
        run_test!
      end

    end
  end



end
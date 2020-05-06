# spec/integration/videos_spec.rb
require 'swagger_helper'
include ActionDispatch::TestProcess
include Rack::Test::Methods

describe 'Video API' do

  path '/api/v1/videos' do
    post 'Uploads videos by authorized user' do
      tags 'Videos'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string #, default: 'Token 8b6a04aac0264bef89d99c3cc5fd8513'

      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :video, in: :formData, required: true, schema: {
        type: :object,
        properties: {
            input_video: { type: :file, example: Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/videos/nature.mp4")) },
            start_time_trim: { type: :integer, example: 10 },
            end_time_trim: { type: :integer, example: 50 }
          },
        required: %w[start_time_trim end_time_trim input_video]
      }

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
        let(:video) { {  input_video: Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/videos/nature.mp4")), start_time_trim: 10, end_time_trim: 50  } }
        run_test!
      end

      response '422', :invalid_request do
        let!(:user){ FactoryBot.create(:user) }
        let(:Authorization) { 'Token ' + user.access_token }
        let(:video) { { start_time_trim: 10 } }
      end

    end
  end

  path '/api/v1/videos' do
    get 'Get list all video by specific user' do
      tags 'User Videos'
      consumes 'application/json'
      parameter name: :Authorization, in: :header, type: :string, default: 'Token 8b6a04aac0264bef89d99c3cc5fd8513'
      parameter name: :page, in: :query, type: :integer, description: 'Page number. Default: 1', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'Per page items. Default: 30', required: false

      response '200', :success do
        let!(:user) { FactoryBot.create(:user) }
        let(:Authorization) { 'Token ' + user.access_token }
        let(:video){ FactoryBot.create(:video, user: user) }
        run_test!
      end
    end
  end

  path '/api/v1/videos/{id}/reload' do
    post 'Reload video by id' do
      tags 'Reload Video'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, default: 'Token 8b6a04aac0264bef89d99c3cc5fd8513'
      parameter name: :id, in: :path, type: :string
      response '200', :success do
        schema type: :object,
               properties: {
                 collection: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       input_video: {
                         type: :object,
                         properties: {
                           url: { type: :string },
                           duration: { type: :integer }
                         }
                       },
                       output_video: {
                         type: :object,
                         properties: {
                           url: { type: :string },
                           duration: { type: :integer }
                         }
                       },
                       processing_errors: { type: :string },
                       start_time_trim: { type: :integer },
                       end_time_trim: { type: :integer },
                       input_video_duration: { type: :integer },
                       output_video_duration: { type: :integer },
                       status: { type: :string },
                       created_at: { type: :string },
                       updated_at: { type: :string }
                     }
                   }
                 }
               }
        let!(:user) { FactoryBot.create(:user) }
        let(:Authorization) { 'Token ' + user.access_token }
        let(:id){ FactoryBot.create(:video, user: user, aasm_state: 'failed').id }
        run_test!
      end

      response '404', :not_found do
        let!(:user) { FactoryBot.create(:user) }
        let(:Authorization) { 'Token ' + user.access_token }
        let(:id) { 'invalid' }
        run_test!
      end

    end
  end

end
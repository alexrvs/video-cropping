# spec/integration/videos_spec.rb
require 'swagger_helper'

describe 'Video API' do

  path '/api/v1/videos' do
    parameter name: :video, in: :formData, schema: {
      type: :object,
      properties: {
        start_time_trim: { type: :integer },
        end_time_trim: { type: :integer }
      },
      required: [ 'start_time_trim', 'end_time_trim' ]
    }
    post 'Uploads a user video' do
      tags 'Videos'
      description
      consumes 'multipart/form-data'
      parameter name: :video, in: :formData, type: :file, required: true
      response '200', 'video created' do
        let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/videos/nature.mp4")) }
          #run_test!
      end
    end
  end

end
# spec/integration/videos_spec.rb
require 'swagger_helper'

describe 'Video API' do

  path '/api/v1/videos' do
    parameter name: :file, :in => :formData, :type => :file, required: true
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
      description 'Upload a video for specific user by token'
      consumes 'multipart/form-data'
      # parameter name: :video, in: :formData, schema: {
      #     type: :object,
      #     properties: {
      #         start_time_trim: { type: :integer },
      #         end_time_trim: { type: :integer }
      #     },
      #     required: [ 'start_time_trim', 'end_time_trim' ]
      # }
      parameter name: :file, :in => :formData, :type => :file, required: true

      response '200', 'blog updated' do
        let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/thumbnail.png")) }
        run_test!
      end
    end
  end

  path '/blogs/flexible' do
    post 'Creates a blog flexible body' do
      tags 'Blogs'
      description 'Creates a flexible blog from provided data'
      operationId 'createFlexibleBlog'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :flexible_blog, in: :body, schema: {
          oneOf: [
              { '$ref' => '#/definitions/blog' },
              { '$ref' => '#/definitions/flexible_blog' }
          ]
      }

      let(:flexible_blog) { { blog: { headline: 'my headline', text: 'my text' } } }

      response '201', 'flexible blog created' do
        schema oneOf: [{ '$ref' => '#/definitions/blog' }, { '$ref' => '#/definitions/flexible_blog' }]
        run_test!
      end
    end
  end

end
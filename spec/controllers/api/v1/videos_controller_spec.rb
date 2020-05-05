require 'rails_helper'
include ActionDispatch::TestProcess::FixtureFile

RSpec.describe Api::V1::VideosController, type: :api do

  describe 'POST create' do
    context 'user authenticated' do
      before do
        auth_as_a_valid_user
      end

      before :each do
        @video = create(:video)
        @file = @video.input_video
        @fixture_file = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/videos/nature.mp4"),'video/mp4')
      end

      context 'with valid params' do
        before do

          @params = {
            'video' => {
              'start_time_trim' => 10,
              'end_time_trim' => 70,
              'input_video' => @fixture_file
            }
          }
        end

        it 'should create video and return json data of created video' do
          post "/api/v1/videos", @params, @auth_params

          expect(last_response.status).to equal(201)

          expect(JSON.parse(last_response.body)['start_time_trim']).to equal @params['video']['start_time_trim']
          expect(JSON.parse(last_response.body)['end_time_trim']).to equal @params['video']['end_time_trim']

          expect(JSON.parse(last_response.body)['status'].to_s).to eq("done")

          video = @user.videos.last

          expect(JSON.parse(last_response.body)['input_video']['url']).to eql video.input_video.url

        end

      end

      context 'with invalid params' do
        before do
          @params = {
            "video" => {
              "end_time_trim" => 15
            }
          }
        end

        it 'should not create video and return error' do
          post "/api/v1/videos", @params, @auth_params

          expect(last_response.status).to equal(422)

          expected_errors = {"message" => {
                                  "error" => "Input video can't be blank, Start time trim can't be blank, Start time trim is not a number",
                                    "details" => {
                                        "input_video" => ["can't be blank"],
                                        "start_time_trim" => ["can't be blank", "is not a number"]
                                    }
                                  }
                                }

          expect(JSON.parse(last_response.body)).to match(expected_errors)


        end
      end

    end

    context 'when use is not authorized' do
      before :each do
        @video = create(:video)
        @file = @video.input_video
        @fixture_file = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/videos/nature.mp4"),'video/mp4')
      end


      it "should not create video" do
        expect { post "/api/v1/videos", @params, {} }.to_not change { Video.count }
      end

      it "return error for unauthorized user" do
        post '/api/v1/videos', @params

        expect(last_response.status).to equal(401)

        expect(JSON.parse(last_response.body)['error'].to_s).to eq("HTTP Token: Access denied.")

      end

    end


  end

  describe "GET index" do

    context 'when use is not authorized' do
      before :each do
        @video = create(:video)
        @file = @video.input_video
        @fixture_file = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/videos/nature.mp4"),'video/mp4')
      end


      it "should not create video" do
        expect { post "/api/v1/videos", @params, {} }.to_not change { Video.count }
      end

      it "return error for unauthorized user" do
        post '/api/v1/videos', @params

        expect(last_response.status).to equal(401)

        expect(JSON.parse(last_response.body)['error'].to_s).to eq("HTTP Token: Access denied.")

      end

    end


    context 'when user is authenticated' do
      before do
        auth_as_a_valid_user
      end

      context "with valid params" do
        before do
          @videos = []
          3.times do
            v = FactoryBot.create(:video)
            v.user = @user
            @videos << v
          end
          @videos
        end

        it "should return list videos in descending creation order" do
          get "/api/v1/videos", {}, { 'HTTP_AUTHORIZATION' => "Token #{@user.access_token}"}

          expect(last_response.status).to eql (200)

          expect(JSON.parse(last_response.body)).to be_kind_of(Array)
          expect(JSON.parse(last_response.body).size).to eql(3)

        end

        context 'when pagination params are provided' do
          before do
            @params = {
                "per_page" => 2,
                "page" => 1
            }
          end

          it "should return specified page only" do
            get "/api/v1/videos", @params, { 'HTTP_AUTHORIZATION' => "Token #{@user.access_token}"}

            expect(last_response.status).to eql (200)

            expect(JSON.parse(last_response.body)).to be_kind_of(Array)
            expect(JSON.parse(last_response.body).size).to eql(2)

          end
        end
      end
    end
  end

end
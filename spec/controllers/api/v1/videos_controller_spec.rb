require 'rails_helper'

RSpec.describe Api::V1::VideosController, type: :api do

  describe 'POST create' do
    context 'user authenticated' do
      before do
        auth_as_a_valid_user
      end

      before :each do
        @video = create(:video)
        @file = @video.input_video
      end

      context 'with valid params' do
        before do
          @params = {
            'video' => {
              'start_time_trim' => 10,
              'end_time_trim' => 70,
              'input_video' => @file
            }
          }
        end

        it 'should create video and return json data of created video' do

          post 'api/v1/videos', params: @params, headers: @auth_params
          #expect{  }.to change {@user.videos.count }.by(1)

          expect(last_response).to equal(201)


          expect(JSON.parse(last_response.body)['start_time_trim']).to equal @params['video']['start_time_trim']
          expect(JSON.parse(last_response.body)['end_time_trim']).to equal @params['video']['end_time_trim']

          expect(JSON.parse(last_response.body)['status']).to equal 'scheduled'

          video = @user.video.last

          expect(JSON.parse(last_response.body)['input_video']['url']).to equal video.input_video.url

        end

      end
    end
  end



  describe "GET index" do


  end



end

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :video do
    association(:user)
    input_video { fixture_file_upload("#{Rails.root}/spec/fixtures/videos/nature.mp4", 'video/mp4')}
    input_video_duration { 60 }
    output_video_processing { false }
    start_time_trim { 10 }
    end_time_trim { 50 }
  end
end

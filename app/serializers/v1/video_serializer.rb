class V1::VideoSerializer < ActiveModel::Serializer

  attributes :id, :input_video, :output_video, :processing_errors,
             :start_time_trim, :end_time_trim, :input_video_duration,
             :output_video_duration, :status, :created_at, :updated_at


  def id
    object.id.to_s
  end

  def status
    object.aasm_state
  end

  def input_video
    {
      url: object.input_video.url,
      duration: object.input_video_duration
    }
  end

  def output_video
    {
        url: object.output_video.url,
        duration: object.output_video_duration
    }
  end
end


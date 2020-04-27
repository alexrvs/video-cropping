class VideoSerializer < ActiveModel::Serializer
  attributes :id, :file, :file_processing, :start_time_trim, :end_time_trim,
             :input_video_duration, :output_video_duration, :status


  def status
    object.aasm_state
  end

end


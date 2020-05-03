class VideoTrimService

  attr_reader :video, :uploader

  def initialize(video)
    @video = video
  end

  def call
    begin
      video.start!
      validate!
      crop_video!
    rescue FFMPEG::Error => e
      video.processing_errors = e.message
      video.fail!
    rescue Exception => e
      video.processing_errors = e.message
      binding.pry
      video.fail!
    end
  end

  private

  def validate!
    has_input_video_attributes = video.input_video_file? && video.input_video_duration?
    valid_start_trim_time = video.start_time_trim < video.input_video_duration.to_i
    valid_end_trim_time = video.end_time_trim < video.input_video_duration.to_i
    raise Exception, "Input file doesn't uploaded" unless has_input_video_attributes
    #raise ExceptionHandler unless has_input_video_attributes
    raise Exception, 'Start or End time greater than input video duration' unless valid_start_trim_time && valid_end_trim_time

    true
  end

  def crop_video!
    file = prepare_output_tmp_file
    video.output_video = file
    video.completed!
  end

  def prepare_output_tmp_file
    video.save!
    pre_file = File.new(video.input_video.path)
    ActionDispatch::Http::UploadedFile.new(tempfile: pre_file,
                                           filename: File.basename(pre_file),
                                           type: MIME::Types.type_for(video.input_video_file)
                                                     .first.content_type
                                          )
  end

end

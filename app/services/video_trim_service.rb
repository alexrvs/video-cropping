class VideoTrimService

  attr_reader :video, :uploader

  def initialize(video)
    @video = video
  end

  def call
    begin
      video.start!
      crop_video!
    rescue FFMPEG::Error => e
      video.processing_errors = e.message
      video.fail!
    rescue Exception => e
      video.processing_errors = e.message
      video.fail!
    end
  end

  private

  def validate!
    video.output_video_duration < video.input_video_duration
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

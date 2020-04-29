class VideoTrimService

  attr_accessor :video

  def initialize(video)
    @video = video
  end

  def call
    begin
      @video.start!
      crop_video!
    rescue Exception => e
      video.failed!
    end
  end

  private

  def validate_input_video

  end

  def validate_video_duration

  end

  def crop_video!
    File.open(tmp_file_path, "r") do |file|
      @video.output_video = file
      @video.complete!
    end
    @video.save!
  end

end

class VideoTrimService

  attr_accessor :video

  def initialize(video)
    @video = video
  end

  def call
    begin
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
    video = FFMPEG::Movie.new(video.input_video.path)
    video.transcode(video.output_video.path, [
        "-ss", video.start_time_trim.to_s,
        "-t", (video.end_time_trim - video.start_time_trim).to_s
    ])
  end



end

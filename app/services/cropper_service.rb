class CropperService
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def call
    if video.input_video_file.present?
      ffmpeg_video = FFMPEG.Movie.new(video.input_video_file.path)
      video.update_attribute(:input_video_duration, ffmpeg_video.duration)
    end
  end

end
class CropperService
  attr_reader :video, :file_type

  def initialize(video, file_type)
    @video = video
    @file_type = file_type
  end

  def call
    if video.send("#{self.file_type}")
      ffmpeg_video = FFMPEG::Movie.new(video.send("#{self.file_type}").path)
      video.update_attribute("#{self.file_type}_duration", ffmpeg_video.duration)
    end
  end

end
class VideoActiveJobWorker < ApplicationJob

  def perform(input_video)
    VideoTrimService.new(input_video).call
  end
end
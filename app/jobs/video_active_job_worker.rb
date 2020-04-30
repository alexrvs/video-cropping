class VideoActiveJobWorker < ApplicationJob
  queue_as :carrierwave

  def perform(video)
    VideoTrimService.new(video).call
  end
end
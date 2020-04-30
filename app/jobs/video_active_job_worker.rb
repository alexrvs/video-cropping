class VideoActiveJobWorker < ApplicationJob
  #include ::CarrierWave::Workers::ProcessAssetMixin
  #include ::CarrierWave::Workers::StoreAssetMixin
  queue_as :carrierwave

  def perform(video)
    VideoTrimService.new(video).call
  end

  after_perform do
    # After the process is completed, send an email
  end
end
class VideoActiveJobWorker < ApplicationJob
  include ::CarrierWave::Workers::ProcessAsset::Base


  def perform(input_video)
    VideoTrimService.new(input_video).call
  end

  after_perform do
    test_perform
  end

  def when_not_ready
    retry_job
  end


  private

  def test_perform
    puts "Success"
  end

end
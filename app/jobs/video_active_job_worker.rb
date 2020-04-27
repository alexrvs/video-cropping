class VideoActiveJobWorker < ApplicationJob
  include ::CarrierWave::Workers::ProcessAsset::Base

  after_perform do
    test_perform
  end

  def when_not_ready
    retry_job
  end


  private

  def test_perform

  end

end
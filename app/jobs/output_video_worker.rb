class OutputVideoWorker < ::CarrierWave::Workers::ProcessAsset
  def perform(*args)
    set_args(*args)
    record = constantized_resource.find id
    if record && record.send(:"#{column}").present?
      record.send(:"process_#{column}_upload=", true)
      if record.send(:"#{column}").recreate_versions! && record.respond_to?(:"#{column}_processing")
        record.update_attribute :"#{column}_processing", false
        CropperService.new(record, :output_video).call
      end
    end
  end
end
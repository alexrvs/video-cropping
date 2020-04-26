class VideoSerializer < ActiveModel::Serializer
  attributes :id, :file, :file_tmp, :file_processing, :start_time_trim, :end_time_trim
end

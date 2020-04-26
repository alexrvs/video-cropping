class Video
  include Mongoid::Document
  include Mongoid::Timestamps
  field :file, type: String
  field :file_tmp, type: String
  field :file_processing, type: Mongoid::Boolean
  field :start_time_trim, type: Integer
  field :end_time_trim, type: Integer
end

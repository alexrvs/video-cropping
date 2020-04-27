class Video
  include Mongoid::Document
  include Mongoid::Timestamps
  field :file, type: String
  field :file_tmp, type: String
  field :file_processing, type: Mongoid::Boolean
  field :start_time_trim, type: Integer
  field :end_time_trim, type: Integer

  belongs_to :user, inverse_of: :video

  mount_uploader :file, VideoUploader, mount_on: :file

  process_in_background :file

  store_in_background :file

  validates_presence_of :file

end

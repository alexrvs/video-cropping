class Video
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  field :file, type: String
  field :file_tmp, type: String
  field :file_processing, type: Mongoid::Boolean
  field :start_time_trim, type: Integer
  field :end_time_trim, type: Integer
<<<<<<< HEAD
  field :input_video_duration, type: Integer
  field :input_video_duration, type: Integer
  field :state, type: String
=======
>>>>>>> feature/carrierwave-uploader

  belongs_to :user, inverse_of: :video

  mount_uploader :file, VideoUploader, mount_on: :file

  process_in_background :file

  store_in_background :file

  validates_presence_of :file

<<<<<<< HEAD

  # aasm column: 'state' do
  #   state :scheduled
  #   state :processing
  #   state :done
  #   state :failed
  #
  #   event :start do
  #
  #   end
  #
  # end

=======
>>>>>>> feature/carrierwave-uploader
end

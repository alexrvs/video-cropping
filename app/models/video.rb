class Video
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  field :file, type: String
  field :file_processing, type: Mongoid::Boolean
  field :start_time_trim, type: Integer
  field :end_time_trim, type: Integer
  field :input_video_duration, type: Integer
  field :output_video_duration, type: Integer
  field :aasm_state, type: String

  belongs_to :user, inverse_of: :video

  mount_uploader :input_video, VideoUploader, mount_on: :input_video_file
  mount_uploader :output_video, VideoTrimUploader, mount_on: output_video_file

  process_in_background :file

  store_in_background :file

  validates_presence_of :file

  validate :start_time_trim, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validate :end_time_trim, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  aasm do
    state :scheduled
    state :processing
    state :done
    state :failed

    event :start do
      transitions from: :scheduled, to: :processing, if: :processing_needed?
    end

    event :completed do
      transitions from: :processing, to: :done
    end

    event :failed do
      transitions from: :processing, to: :failed

    end

    event :restart do
      transitions from: :failed, to: :scheduled
    end

  end

end

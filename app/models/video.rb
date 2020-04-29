class Video
  include GlobalID::Identification
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  field :input_video, type: String
  field :input_video_tmp, type: String
  field :input_video_processing, type: Mongoid::Boolean
  field :output_video, type: String
  field :start_time_trim, type: Integer
  field :end_time_trim, type: Integer
  field :input_video_duration, type: Integer
  field :output_video_duration, type: Integer
  field :aasm_state, type: String

  belongs_to :user, inverse_of: :video

  mount_uploader :input_video, VideoUploader, mount_on: :input_video
  process_in_background :input_video
  store_in_background :input_video

  validates_presence_of :input_video

  mount_uploader :output_video, VideoTrimUploader, mount_on: :output_video

  validates :start_time_trim, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :end_time_trim, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  aasm do
    state :scheduled, initial: true
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

  def run_worker!
    if self.scheduled?
      VideoActiveJobWorker.perform_later(self)
    end
  end

  def restart!
    self.schedule!
    self.run_worker!
  end

end
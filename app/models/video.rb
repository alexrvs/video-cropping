class Video
  include GlobalID::Identification
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  field :input_video, type: String
  field :output_video, type: String
  field :output_video_tmp, type: String
  field :output_video_processing, type: Mongoid::Boolean
  field :start_time_trim, type: Integer
  field :end_time_trim, type: Integer
  field :input_video_duration, type: Integer
  field :output_video_duration, type: Integer
  field :aasm_state, type: String
  field :processing_errors, type: String

  belongs_to :user, inverse_of: :video

  mount_uploader :input_video, VideoUploader, mount_on: :input_video_file
  validates_presence_of :input_video

  mount_uploader :output_video, VideoTrimUploader, mount_on: :output_video_file
  process_in_background :output_video, OutputVideoWorker

  validates :start_time_trim, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :end_time_trim, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  aasm do
    state :scheduled, initial: true
    state :processing
    state :done
    state :failed

    event :schedule do
      transitions from: :failed, to: :scheduled
    end

    event :start do
      transitions from: :scheduled, to: :processing
      before do
        self.output_video_processing = true
      end
    end

    event :completed do
      transitions from: :processing, to: :done
      after do
        self.output_video_processing = false
      end
    end

    event :fail do
      transitions from: :processing, to: :failed
      after do
        self.output_video_processing = true
      end
    end

  end

  def run_worker!
    if self.scheduled?
      VideoTrimService.new(self).call
    end
  end

  def restart!
    self.schedule!
    run_worker!
  end

end
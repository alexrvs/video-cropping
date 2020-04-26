class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :access_token, type: String

  has_many :videos, inverse_of: :user, dependent: :destroy

  before_create :set_access_token


  private

  def set_access_token
    return if access_token.present?
    self.access_token = generate_access_token
  end

  def generate_access_token
    SecureRandom.uuid.gsub(/\-/,'')
  end

end

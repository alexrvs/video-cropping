#https://gist.github.com/alex-zige/5795358
module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end
end
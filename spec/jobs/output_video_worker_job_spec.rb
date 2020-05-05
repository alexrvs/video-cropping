require 'rails_helper'

RSpec.describe OutputVideoWorker, type: :job do
  let(:video) {build_stubbed(:video)}

  subject(:job){described_class.perform_later(video)}

end
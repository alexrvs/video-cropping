require 'rails_helper'

RSpec.describe User, type: :model do
  context "associations" do
    it {is_expected.to have_many(:videos).as_inverse_of(:user).with_dependent(:destroy) }
  end

  context  "unique access token generation" do
    it {expect(3.times.map {FactoryBot.create(:user)}.map{|u| u.access_token}.uniq.count ).to eql 3 }
  end

end

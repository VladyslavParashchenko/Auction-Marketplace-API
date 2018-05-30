require 'rails_helper'

RSpec.describe User, :type=> :model do
  context "test for user age"
  it "has valid age" do
    user = build(:adult_user)
    expect(user.valid?).to be_truthy
    end
  it "has not valid age" do
    user = build(:young_user)
    expect(user.errors[:birthday].empty?).to be_truthy
  end
end
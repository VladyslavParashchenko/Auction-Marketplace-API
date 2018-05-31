# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  birthday   :datetime
#  email      :string
#  first_name :string
#  last_name  :string
#  password   :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe User, :type=> :model do
  context "test for user age"
  it "has valid age" do
    user = build(:user)
    expect(user.valid?).to be_truthy
    end
  it "has not valid age" do
    user = build(:young_user)
    expect(user.errors[:birthday].empty?).to be_truthy
  end
end

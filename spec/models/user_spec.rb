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

RSpec.describe User, :type => :model do
  describe "validations" do
    before(:each) do
      subject
    end
    subject do
      user
    end
    let(:user) { build(:user) }
    describe "age validation" do
      context "with ok user" do
        it "is valid" do
          expect(subject.valid?).to be_truthy
        end
      end
      context "with invalid birthday" do
        let(:user) { build(:young_user) }
        it "is invalid" do
          user.valid?
          expect(user.errors[:birthday].empty?).to be_falsey
        end
      end
    end
  end
end
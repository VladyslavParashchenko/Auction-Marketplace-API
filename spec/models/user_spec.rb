# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  birthday               :datetime
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  password               :string
#  phone                  :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

require "rails_helper"

RSpec.describe User, type: :model do
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
          expect(user.errors[:birthday].empty?).to be_truthy
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

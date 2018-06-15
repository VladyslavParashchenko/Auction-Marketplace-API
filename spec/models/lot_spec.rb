# == Schema Information
#
# Table name: lots
#
#  id              :bigint(8)        not null, primary key
#  current_price   :decimal(8, 2)
#  description     :text
#  estimated_price :decimal(8, 2)
#  image           :string
#  lot_end_time    :datetime
#  lot_start_time  :datetime
#  status          :integer          default("pending")
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint(8)
#
# Indexes
#
#  index_lots_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_7afc1a8e38  (user_id => users.id)
#

require "rails_helper"
require "sidekiq/api"
RSpec.describe Lot, type: :model do
  describe "validations" do
    before(:each) do
      subject
    end
    subject do
      lot
    end
    let(:lot) do
      build(:lot, :not_valid_start_time)
    end
    describe "lot validation" do
      context "with invalid start lot" do
        it "return false if errors in lot_start_time" do
          lot.valid?
          expect(lot.errors[:lot_start_time].empty?).to be_falsey
        end
      end
      context "with invalid end_time" do
        let(:lot) do
          build(:lot, :not_valid_end_time)
        end
        it "return false if errors in lot_end_time" do
          lot.valid?
          expect(lot.errors[:lot_end_time].empty?).to be_falsey
        end
      end
    end
  end
  describe "action jobs test " do
    let(:lot) {create(:lot, user: create(:client))}
    describe "create new lot" do
      subject {lot}
      it "2 jobs will be created" do
        expect {subject}.to change {Sidekiq::ScheduledSet.new.size}.by(2)
      end
    end
    describe "changing lot" do
      before(:each) do
        lot
      end
      describe "delete lot" do
        subject { lot.destroy }
        it "2 jobs will be created and deleted" do
          expect {subject}.to change { Sidekiq::ScheduledSet.new.size }.by(-2)
        end
      end
      describe "update lot" do
        subject { lot.update(lot_start_time: Time.now + 3.days) }
        it "2 jobs will be created and deleted" do
          expect { subject }.to change { Sidekiq::ScheduledSet.new.size }.by(0)
        end
      end
    end

  end
end

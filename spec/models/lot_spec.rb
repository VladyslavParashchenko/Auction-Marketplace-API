# frozen_string_literal: true

# == Schema Information
#
# Table name: lots
#
#  id              :bigint(8)        not null, primary key
#  current_price   :decimal(8, 2)
#  description     :text
#  end_jid         :string
#  estimated_price :decimal(8, 2)
#  image           :string
#  lot_end_time    :datetime
#  lot_start_time  :datetime
#  start_jid       :string
#  status          :integer          default("pending")
#  title           :string
#  winner_bid      :integer
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
#  fk_rails_6897db8a79  (winner_bid => bids.id)
#  fk_rails_7afc1a8e38  (user_id => users.id)
#

require "rails_helper"
require "sidekiq/api"
RSpec.describe Lot, type: :model do
  describe "validations" do
    let(:lot) { build(:lot, :not_valid_start_time) }
    describe "lot validation" do
      context "with invalid start lot" do
        it "return false if errors in lot_start_time" do
          lot.valid?
          expect(lot.errors[:lot_start_time].empty?).to be_falsey
        end
      end
      context "with invalid end_time" do
        let(:lot) { build(:lot, :not_valid_end_time) }
        it "should return false if errors in lot_end_time" do
          lot.valid?
          expect(lot.errors[:lot_end_time].empty?).to be_falsey
        end
      end
    end
  end
  describe "action jobs test " do
    let(:lot) { create(:lot, user: create(:client)) }
    describe "create new lot" do
      subject { lot }
      it "2 jobs will be created" do
        ActiveJob::Base.queue_adapter = :sidekiq
        expect { subject }.to change { Sidekiq::ScheduledSet.new.size }.by(2)
      end
    end
    describe "changing lot" do
      describe "update lot" do
        subject { lot.update(lot_start_time: Time.now + 3.days) }
        it "should change jid " do
          lot_old_jid = lot.start_jid
          subject
          expect(lot.start_jid).not_to eq(lot_old_jid)
        end
      end
    end
  end
  describe "lot helper test " do
    before(:each) do
      @lot = create(:lot, :lot_with_bid)
      @bids = @lot.bids
      @lot.update(status: :closed)
    end
    let(:orders) { create(:order, bid: @bids.last) }
    describe "testing lot helpers" do
      it "should find lot winner" do
        expect(@lot.get_winner_bid.user.id).to eq(@bids.last.user.id)
      end
      it "should find bid that won" do
        expect(@lot.get_winner_bid.id).to eq(@bids.last.id)
      end
    end
  end
  describe "test closing lot if set estimated_price" do
    let(:lot) { create(:lot) }
    subject do
      create(:bid, proposed_price: lot.estimated_price, lot: lot)
    end
    it "should close lot" do
      expect { subject }.to change { lot.status }.from("pending").to("closed")
    end
  end
end

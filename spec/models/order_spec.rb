# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id               :bigint(8)        not null, primary key
#  arrival_location :string
#  arrival_type     :integer
#  delivery_company :string
#  status           :integer          default("pending")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bid_id           :bigint(8)
#
# Indexes
#
#  index_orders_on_bid_id  (bid_id)
#
# Foreign Keys
#
#  fk_rails_70594f7ad3  (bid_id => bids.id)
#

require "rails_helper"
RSpec.describe Order, type: :model do
  before(:each) do
    @lot = create(:lot)
  end
  describe "validations" do
    let(:order) { build(:order, lot: @lot) }
    describe "order validation" do
      context "with not closed lot" do
        it "should return bid status validation error" do
          order.valid?
          expect(order.errors[:bid_status].empty?).to be_falsey
        end
      end
      context "with closed lot" do
        before(:each) do
          @lot.update_column(:status, :closed)
        end
        it "should create new bid without errors" do
          order.valid?
          expect(order.errors[:bid_status].empty?).to be_truthy
        end
      end
    end
  end
end

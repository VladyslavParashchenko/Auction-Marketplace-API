require "rails_helper"
require "action_cable/testing/rspec"
require "action_cable/testing/rspec/features"

RSpec.describe BidChannel, type: :channel do
  before do
    @lot = create(:lot, user: create(:client))
  end
  it "subscribes to a stream when lot is provided" do
    subscribe(lot_id: @lot.id)
    expect(subscription).to be_confirmed
    expect(streams).to include("lot##{@lot.id}")
  end
end
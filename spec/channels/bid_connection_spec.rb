# frozen_string_literal: true

require "rails_helper"
require "action_cable/testing/rspec"
require "action_cable/testing/rspec/features"
RSpec.describe "Action cable testing", type: :request do
  before(:each) do
    @user = create(:client)
    @lot = create(:lot, user: @user)
  end
  describe "POST #create" do
    let(:bid) { attributes_for(:bid, lot: @lot) }
    subject do
      post "/lots/#{@lot.id}/bids/", params: bid, headers: @user.create_new_auth_token
    end
    it "should broadcast bid to lot channel" do
      expect { subject }.to have_broadcasted_to("lot##{@lot.id}")
    end
    it "should broadcast a correct proposed_price a new bid" do
      expect { subject }.to have_broadcasted_to("lot##{@lot.id}").with(a_hash_including(proposed_price: bid[:proposed_price].round(2).to_s))
    end
  end
end

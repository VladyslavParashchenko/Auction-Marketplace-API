# frozen_string_literal: true

require "rails_helper"
require "action_cable/testing/rspec"
require "action_cable/testing/rspec/features"
RSpec.describe ApplicationCable::Connection, type: :channel do
  before(:each) do
    @user = create(:client)
    @lot = create(:lot, user: @user)
  end
  it "successfully connects" do
    connect "/lots/#{@lot.id}/", headers: @user.create_new_auth_token
    expect(connection.current_user.id).to eq(@user.id)
  end
  it "rejects connection" do
    expect { connect "/lots/#{@lot.id}/" }.to have_rejected_connection
  end
end

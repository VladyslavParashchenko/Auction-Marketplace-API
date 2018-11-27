# frozen_string_literal: true

RSpec.shared_examples "session error" do
  it "should return error message" do
    subject
    data = json_parse(response.body)
    expect(data["errors"].include?("You need to sign in or sign up before continuing.")).to be_truthy
  end
end

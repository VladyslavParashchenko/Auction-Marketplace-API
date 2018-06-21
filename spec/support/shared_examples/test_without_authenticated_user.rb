# frozen_string_literal: true

RSpec.shared_examples "create operation without an authenticated user" do |url|
  subject do
    post url
  end
  it "try create lot without user" do
    subject
    data = json_parse(response.body)
    expect(data["errors"].include? "You need to sign in or sign up before continuing.").to be_truthy
  end
end

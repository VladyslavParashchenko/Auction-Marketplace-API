# frozen_string_literal: true

RSpec.shared_examples "return permission error" do
  it "should return permission error" do
    subject
    data = json_parse(response.body)
    expect(data["errors"]["error"]).to eq("You do not have rights to this action")
  end
end

require "rails_helper"

RSpec.describe StatusHandlerJob, type: :job do
  before(:each) do
    @user = create(:client)
    @lot = create(:lot, user: @user, status: :pending)
  end
  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      StatusHandlerJob.set(wait_until: @lot.lot_start_time).perform_later(@lot.id, "in_process")
    }.to have_enqueued_job(StatusHandlerJob)
  end
end

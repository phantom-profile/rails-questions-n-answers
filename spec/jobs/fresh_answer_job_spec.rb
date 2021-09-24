require 'rails_helper'

RSpec.describe FreshAnswerJob, type: :job do
  let(:service) { double('EmailSending::FreshAnswer') }
  let(:users) { create_list(:user, 2) }
  let(:answer) { create(:answer) }

  before do
    allow(EmailSending::FreshAnswer).to receive(:new).and_return(service)
  end

  it 'calls Services::FreshAnswer#send_notification' do
    expect(service).to receive(:send_notification).with(users, answer)
    FreshAnswerJob.perform_now(users, answer)
  end
end

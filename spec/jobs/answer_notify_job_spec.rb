require 'rails_helper'

RSpec.describe AnswerNotifyJob, type: :job do
  let(:service) { double('AnswerNotify') }
  let(:answer) { create(:answer) }

  before do
    allow(AnswerNotify).to receive(:new).and_return(service)
  end

  it 'calls DailyDigest#send_digest' do
    expect(service).to receive(:send_notify).with(answer)

    AnswerNotifyJob.perform_now(answer)
  end
end
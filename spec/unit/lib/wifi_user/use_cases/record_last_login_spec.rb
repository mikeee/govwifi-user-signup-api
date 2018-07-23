require 'spec_helper'

describe WifiUser::UseCase::RecordLastLogin do
  subject { described_class.new(user_gateway: spy_user_gateway) }

  let(:today) { DateTime.now }
  let(:spy_user_gateway) { spy(set_last_login: nil) }

  context 'for a user' do
    let(:username) { 'jdorhd' }
    let(:today) { DateTime.now }

    context 'on first login' do
      it 'passes the details to the gateway' do
        expect(spy_user_gateway).to receive(:set_last_login)
          .with(username: username, datetime: today)
        subject.execute(username: username, datetime: today)
      end
    end
  end

  context 'for different user' do
    let(:username) { 'foobea' }
    let(:yesterday) { DateTime.now - 1 }

    context 'on first login' do
      it 'passes the details to the gateway' do
        expect(spy_user_gateway).to receive(:set_last_login)
          .with(username: username, datetime: yesterday)
        subject.execute(username: username, datetime: yesterday)
      end
    end
  end
end

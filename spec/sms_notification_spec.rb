RSpec.describe App do
  describe 'POSTing an SMS to /user-signup/sms-notification' do
    let(:from_phone_number) { '07700900000' }

    def post_sms_notification
      post '/user-signup/sms-notification', source: from_phone_number, message: 'Go'
    end

    it 'returns no sensitive information to sms provider' do
      allow_any_instance_of(SmsSignup).to receive(:execute).and_return 'Sensitive info'
      post_sms_notification
      expect(last_response.body).to eq('')
    end

    describe 'from a phone number' do
      let(:from_phone_number) { '07700900000' }

      it 'calls SmsSignup#execute' do
        expect_any_instance_of(SmsSignup).to \
          receive(:execute).with(contact: from_phone_number)
        post_sms_notification
      end
    end

    describe 'from a different phone number' do
      let(:from_phone_number) { '07700900001' }
      it 'calls SmsSignup#execute' do
        expect_any_instance_of(SmsSignup).to \
          receive(:execute).with(contact: from_phone_number)
        post_sms_notification
      end
    end
  end
end
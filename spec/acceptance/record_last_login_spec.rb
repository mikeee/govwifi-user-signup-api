describe 'record last login' do
  subject { WifiUser::UseCase::RecordLastLogin.new }

  # Noticed teardown in other tests - might need it here?
  let(:users) { WifiUser::Repository::User.new }
  let(:user_id) { 1 }
  let(:yesterday) { DateTime.now - 24 * 60 * 60 }
  let(:today) { Datetime.now }

  context 'on first login' do
    before do
      subject.execute(user_id: user_id, datetime: yesterday)
    end

    # I don't want to Sequel for these assertions, but
    # tricky without a corresponding 'read' use case
    it 'records a new entry' do
      expect(users.exists?(id: user_id)).to be(true)
    end

    it 'records the right time' do
      expect(users.where(id: user_id).last_login).to eq(yesterday)
    end

    context 'on second login' do
      before do
        subject.execute(user_id: user_id, datetime: today)
      end

      it 'records the right time' do
        expect(users.where(id: user_id).last_login).to eq(today)
      end
    end
  end
end

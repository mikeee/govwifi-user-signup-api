xdescribe 'record last login' do
  subject { WifiUser::UseCase::RecordLastLogin.new }

  # Noticed teardown in other tests - might need it here?
  let(:users) { WifiUser::Repository::User.new }
  let(:username) { 1 }
  let(:yesterday) { DateTime.now - 1 }
  let(:today) { Datetime.now }

  context 'on first login' do
    before do
      subject.execute(username: username, datetime: yesterday)
    end

    # I don't want to Sequel for these assertions, but
    # tricky without a corresponding 'read' use case
    it 'records a new entry' do
      expect(users.exists?(username: username)).to be(true)
    end

    it 'records the right time' do
      expect(users.where(username: username).last_login).to eq(yesterday)
    end

    context 'on second login' do
      before do
        subject.execute(username: username, datetime: today)
      end

      it 'records the right time' do
        expect(users.where(username: username).last_login).to eq(today)
      end
    end
  end
end

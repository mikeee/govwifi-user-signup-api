describe WifiUser::Gateway::Users do
  subject { described_class.new }

  let(:users) { DB[:userdetails] }
  let(:user) { users.first(username: username) }
  let(:time) { Time.now.round(0) }

  context 'example 1' do
    let(:username) { 'abcde' }

    context 'for an existing user' do
      before { users.insert(username: username)}

      it 'records the login time' do
        subject.set_last_login(username: username, datetime: time)
        expect(user[:last_login]).to eq(time)
      end
    end
  end

  context 'example 2' do
    let(:username) { 'qwopy' }

    context 'for an existing user' do
      before { users.insert(username: username)}

      it 'records the login time' do
        subject.set_last_login(username: username, datetime: time)
        expect(user[:last_login]).to eq(time)
      end
    end
  end

  context 'for a missing user' do
    it 'does not blow up' do
      expect{subject.set_last_login(
        username: 'mssng',
        datetime: DateTime.now
      )}.to_not raise_error
    end
  end
end

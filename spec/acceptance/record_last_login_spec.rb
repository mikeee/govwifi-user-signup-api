describe App do
  describe 'record last login' do
  # Noticed teardown in other tests - might need it here?
    let(:users) { DB[:userdetails] }
    let(:user) { users.first(username: username) }
    let(:yesterday) { Time.now.round - 1 }
    let(:today) { Time.now.round }

    context 'on first login' do
      let(:username) { 1 }

      before do
        users.insert(username: username)
        post('/user-signup/record-last-login', {
          username: username,
          datetime: yesterday.iso8601
        })
      end

      it 'records the right time' do
        expect(user[:last_login]).to eq(yesterday)
      end

      context 'on second login' do
        let(:username) { 2 }

        before do
          post('/user-signup/record-last-login', {
            username: username,
            datetime: today.iso8601
          })
        end

        it 'records the right time' do
          expect(user[:last_login]).to eq(today)
        end
      end
    end
  end
end

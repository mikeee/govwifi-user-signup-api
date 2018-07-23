class WifiUser::Gateway::Users
  def set_last_login(username:, datetime:)
    users = Sequel::Model(:userdetails)
    users.where(username: username).update(last_login: datetime)
  end
end

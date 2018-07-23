class WifiUser::UseCase::RecordLastLogin
  def initialize(user_gateway:)
    @user_gateway = user_gateway
  end

  def execute(username:, datetime:)
    @user_gateway.set_last_login(username: username, datetime: datetime)
  end
end

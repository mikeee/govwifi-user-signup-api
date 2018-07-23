require 'sinatra/base'
require 'net/http'

require './lib/loader'

class App < Sinatra::Base
  configure :production, :staging, :development do
    enable :logging
  end

  get '/healthcheck' do
    'Healthy'
  end

  post '/user-signup/record-last-login' do
    thing = WifiUser::UseCase::RecordLastLogin.new(user_gateway: WifiUser::Gateway::Users.new)
    thing.execute(username: params[:username], datetime: params[:datetime])
  end

  post '/user-signup/email-notification' do
    WifiUser::UseCase::SnsNotificationHandler.new(logger).handle(request)
  end

  post '/user-signup/sms-notification' do
    logger.info("Processing SMS on /user-signup/sms-notification from #{params[:source]} with message #{params[:message]}")

    template_finder = WifiUser::UseCase::SmsTemplateFinder.new(environment: ENV.fetch('RACK_ENV'))

    WifiUser::UseCase::SmsResponse.new(
      user_model: WifiUser::Repository::User.new,
      template_finder: template_finder
    ).execute(
      contact: params[:source],
      sms_content: params[:message]
    )
    ''
  end
end

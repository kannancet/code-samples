module Stockman
  class UserNotifier

    EMAIL_FROM = ENV.fetch('EMAIL_FROM').freeze
    EMAIL_SUBJECT = ENV.fetch('EMAIL_SUBJECT').freeze

    attr_accessor :user, :output

    def initialize user:, output:
      @user = user
      @output = output
    end

    def call
      Pony.mail(to: user.email,
                  from: EMAIL_FROM,
                  subject: EMAIL_SUBJECT,
                  body: email_body,
                  via: :smtp,
                  via_options: $email_gateway)
    end

    private

    def email_body
      sentence1 = "Hi #{user.name}, Your stock calculations from date #{user.start_date} for stock code #{user.stock_code} are :"
      sentence2 = "RETURN RATE is #{output.stock_return}% and DRAWDOWN RATE is #{output.stock_drawdown}%."

      [sentence1, sentence2].join(' ')
    end

  end
end

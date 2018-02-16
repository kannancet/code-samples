FactoryBot.define do
  factory :user, class: Stockman::User do
    name 'Kannan'
    email 'pivotalbits@gmail.com'
    start_date '2017-12-01'
    stock_code 'AAPL'
  end
end

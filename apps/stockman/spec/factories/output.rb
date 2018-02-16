FactoryBot.define do
  factory :output, class: Stockman::Output do
    stock_return 1.5
    stock_drawdown 2
  end
end

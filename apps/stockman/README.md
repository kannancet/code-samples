# Stockman

Welcome to Stockman! Stockman is a command line tool to help you calculate your return rate and drawdown rate for Stocks.

## Setup environment
Setup environment variables in .env file in root folder:
  ```ruby
  QUANDL_API_KEY = 'Your Quandl API Key'
  SMTP_USERNAME='Your SMTP username'
  SMTP_PASSWORD='Your  SMTP password'
  EMAIL_FROM='pivotalbits@gmail.com'
  ```

## How to run the program ?
Go to the root folder:
  ```ruby
  cd stockman
  bundle install
  ```

Start the stockman:
  ```ruby
  ruby stockman_start.rb
  ```

## How To Test the App ?
  ```ruby
  rspec spec
  ```

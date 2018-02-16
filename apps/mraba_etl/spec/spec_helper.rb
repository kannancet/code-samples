require 'bundler/setup'
require 'active_support/all'

Dir[Dir.pwd + "/spec/support/**/*.rb"].each{|file| require file}

require 'mraba_etl'

RSpec.configure do |config|
end

require 'active_support/all'
require 'dotenv'
require 'pry'
require 'net/sftp'
require 'csv'
require 'date'
require 'iconv'

Dotenv.load

#Loading all dependent files
Dir[Dir.pwd + "/lib/mraba_etl/config/**/*.rb"].each{|file| require file}
Dir[Dir.pwd + "/lib/mraba_etl/helpers/**/*.rb"].each{|file| require file}
Dir[Dir.pwd + "/lib/mraba_etl/models/**/*.rb"].each{|file| require file}
Dir[Dir.pwd + "/lib/mraba_etl/services/actions/base.rb"].each{|file| require file}
Dir[Dir.pwd + "/lib/mraba_etl/services/actions/*.rb"].each{|file| require file}
Dir[Dir.pwd + "/lib/mraba_etl/services/*.rb"].each{|file| require file}

require 'dotenv'
require 'httparty'
require 'uri'
require 'pry'
require 'pony'
require 'thor'

Dotenv.load

Dir[Dir.pwd + "/lib/stockman/config/**/*.rb"].each{|file| require file}
Dir[Dir.pwd + "/lib/stockman/helper/**/*.rb"].each{|file| require file}
Dir[Dir.pwd + "/lib/stockman/models/**/*.rb"].each{|file| require file}
Dir[Dir.pwd + "/lib/stockman/services/**/*.rb"].each{|file| require file}

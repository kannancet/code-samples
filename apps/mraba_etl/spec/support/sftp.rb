
require 'net/sftp'
require "rspec/mocks/standalone"

sftp_mock = double('sftp', name: 'sftp')
Net::SFTP.stub(:start).and_return(sftp_mock)

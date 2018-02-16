require 'active_support/all'
require 'net/sftp'

sftp_host = (Rails.env == 'production' ? 'csv.example.com/endpoint/' : ENV.fetch('SFTP_HOST'))
$sftp = Net::SFTP.start(sftp_host, ENV.fetch('SFTP_USER'), keys: [ENV.fetch('SFTP_KEYS')])

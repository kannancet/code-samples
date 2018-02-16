$email_gateway = {
  address: 'smtp.gmail.com',
  port: '587',
  enable_starttls_auto: true,
  user_name: ENV.fetch('SMTP_USERNAME'),
  password: ENV.fetch('SMTP_PASSWORD'),
  authentication: :plain,
  domain: 'gmail.com'
}

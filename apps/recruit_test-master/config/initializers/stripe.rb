Rails.configuration.stripe = {
  :publishable_key => "pk_test_bQKadVSr1pM6WE8dmyAz9XZ6",
  :secret_key      => "sk_test_8Bjdwp72NXQ87SMd8q0bc82M"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

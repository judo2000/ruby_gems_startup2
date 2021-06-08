Rails.configuration.stripe = {
  #publishable_key: "#{Rails.application.credentials[Rails.env.to_sym][:stripe][:publishable]}",
  publishable_key: Rails.application.credentials.stripe[:publishable],
  #secret_key: "#{Rails.application.credentials[Rails.env.to_sym][:stripe][:secret]}"
  secret_key: Rails.application.credentials.stripe[:secret]
}
#Stripe.api_key = "#{Rails.application.credentials[Rails.env.to_sym][:stripe][:secret]}"
Stripe.api_key = Rails.application.credentials.stripe[:secret]
# frozen_string_literal: true

Devise.setup do |config|
  # The e-mail address that mail will appear to be sent from
  # If absent, mail is sent from "please-change-me-at-config-initializers-devise@example.com"
  config.mailer_sender = "support@myapp.com"

  # If using rails-api, you may want to tell devise to not use ActionDispatch::Flash
  # middleware b/c rails-api does not include it.
  # See: https://stackoverflow.com/q/19600905/806956
  config.navigational_formats = [:json]

  config.secret_key = "2cafc219dfa18963560369e975788a13f411aa5f2b6e0968e65b9b74f32ec54d9533c3e1565cfb874b077a2efe31e5d056a17b213a62fd0cc2d12c9f54d83f5d"
end

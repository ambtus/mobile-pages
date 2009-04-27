# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mobile-docs_session',
  :secret      => '424f6d4dabacf1dac98ecbb355df377ca3ddec50e6e06a8ead07d8c0e75483b46ac66a1c10fbc263482b45c2f67f107d772c5876b82d2d864b5b3ce7407380fa'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

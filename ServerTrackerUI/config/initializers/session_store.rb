# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ServerTrackerUI_session',
  :secret      => 'abcaef9b5c0c3a7961a59bbc59632c1a45ffa091b1d91ec53fac51b2dc2a2be2276d4128e8658d49d27ee31674ec6beab23c6b606df24611b210f7545c2cb97e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

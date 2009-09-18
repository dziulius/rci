# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_psi_session',
  :secret      => 'e44c4301523f995677fdbac8a4c34d71d78f46aaa3a540ba979d0c6347452817773482f7b64fd6481f54b491e4e5d13ab893391ff3d2e6662b862fb60f454edc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

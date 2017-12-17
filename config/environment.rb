# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Convert keys from the Rails-conventional snake_case to camelCase
Jbuilder.key_format camelize: :lower

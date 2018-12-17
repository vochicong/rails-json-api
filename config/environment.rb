# Load the Rails application.
require_relative 'application'

# Environmental secret and configuration variables
# Env.APP_CONFIG(default) will look for APP_CONFIG
# from environment variables, the `default` value,
# and then from encrypted credentials.
class Env
  def self.method_missing(name, *default)
    ENV[name.to_s] ||
      default.first ||
      Rails.application.credentials.send(name) ||
      super
  end

  def self.respond_to_missing?(*)
    true
  end
end

# Initialize the Rails application.
Rails.application.initialize!

# Convert keys from the Rails-conventional snake_case to camelCase
Jbuilder.key_format camelize: :lower

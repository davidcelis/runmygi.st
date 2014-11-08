require 'active_support/dependencies'

# Set up autoloading.
relative_load_paths = %w[app/apis app/helpers app/models lib]
ActiveSupport::Dependencies.autoload_paths += relative_load_paths

# Set the default Time Zone.
Time.zone_default = RunMyGist::Application.time_zone

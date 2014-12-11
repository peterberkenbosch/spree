require 'active_model'
require 'inflecto'
require 'virtus'

# require exceptions
Dir["./lib/exceptions/**/*.rb"].sort.each { |f| require f }

# require models
Dir["./lib/models/**/*.rb"].sort.each { |f| require f }

# require configuration
Dir["./lib/config/**/*.rb"].sort.each { |f| require f }

Virtus.finalize

# Remove annoying deprecation message
I18n.enforce_available_locales = false

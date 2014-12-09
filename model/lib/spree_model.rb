require 'virtus'
require 'inflecto'
require 'active_model'

# require models
require 'models/spree/address'
require 'models/spree/cart'
require 'models/spree/order'
require 'models/spree/variant'
require 'models/spree/product'
require 'models/spree/promotion'
require 'models/spree/payment'
require 'models/spree/customer'
require 'models/spree/item'
require 'models/spree/credit'
require 'models/spree/shipping_method'
require 'models/spree/shipping_rate'
Virtus.finalize

# require exceptions

require 'exceptions/spree/attribute_locked'

# Remove annoying deprecation message
I18n.enforce_available_locales = false
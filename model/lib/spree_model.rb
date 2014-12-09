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
require 'models/spree/shipment'
require 'models/spree/refund'

Virtus.finalize

# require exceptions
require 'exceptions/spree/attribute_locked'
require 'exceptions/spree/illegal_operation'

# require testing_support
require 'testing_support/spree/samples/order_sample.rb'

# Remove annoying deprecation message
I18n.enforce_available_locales = false

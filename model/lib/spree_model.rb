require 'virtus'
require 'inflecto'
require 'active_model'

# require models
require 'models/spree/order'
require 'models/spree/variant'
require 'models/spree/product'
require 'models/spree/payment'
require 'models/spree/customer'
require 'models/spree/item'
require 'models/spree/credit'
Virtus.finalize

# require exceptions

require 'exceptions/spree/attribute_locked'

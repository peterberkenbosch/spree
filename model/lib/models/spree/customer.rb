module Spree
  class Customer
    include Virtus.model(finalize: false)

    attribute :credits, Array['Spree::Credit']
  end
end

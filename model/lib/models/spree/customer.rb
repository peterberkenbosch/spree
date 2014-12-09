module Spree
  class Customer
    include Virtus.model(finalize: false)

    attribute :payments, Array['Spree::Credit']
  end
end

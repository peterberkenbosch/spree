module Spree
  class Item
    include Virtus.model(finalize: false)

    attribute :variant, 'Spree::Variant'
    attribute :quantity, Integer
  end
end

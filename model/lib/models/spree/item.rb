module Spree
  class Item
    include Virtus.model(finalize: false)

    attribute :variant, 'Spree::Variant'
    attribute :sku, String
    attribute :price, BigDecimal
    attribute :quantity, Integer

    def amount
      price * quantity
    end
  end
end

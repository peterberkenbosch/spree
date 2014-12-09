module Spree
  class Variant
    include Virtus.model(finalize: false)

    attribute :product, 'Spree::Product'
    attribute :sku, String
    attribute :price, BigDecimal
  end
end

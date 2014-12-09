module Spree
  class Product
    include Virtus.model(finalize: false)

    attribute :variants, Array['Spree::Variant']
    attribute :name, String
  end
end

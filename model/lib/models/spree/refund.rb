module Spree
  class Refund

    include Virtus.model(finalize: false)

    attribute :amount, Float, default: 0
    attribute :payments, Array['Spree::Payment']
    attribute :explanation, String
    attribute :created_at, String

  end
end
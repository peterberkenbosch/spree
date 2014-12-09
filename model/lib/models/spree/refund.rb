module Spree
  class Refund

    include Virtus.model(finalize: false)

    attribute :amount, Float, default: 0
    attribute :explanation, String
    attribute :created_at, String
    attribute :user, String

  end
end
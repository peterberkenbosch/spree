module Spree
  class Credit
    include Virtus.model(finalize: false)

    attribute :amount, Float, default: 0

  end
end

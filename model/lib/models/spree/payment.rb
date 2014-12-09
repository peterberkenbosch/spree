module Spree
  class Payment
    include Virtus.model(finalize: false)

    attribute :final, Boolean
  end
end

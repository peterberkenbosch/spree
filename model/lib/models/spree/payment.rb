module Spree
  class Payment

    include Virtus.model

    attribute :final, Boolean

  end
end
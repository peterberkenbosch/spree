module Spree
  class Customer
    include Virtus.model(finalize: false)

    attribute :credits, Array['Spree::Credit']

    def add_credit(credit)
      self.credits << credit
    end

  end
end

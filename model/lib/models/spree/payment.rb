module Spree
  class Payment
    include Virtus.model(finalize: false)

    attribute :canceled, Boolean, :default => false
    attribute :refunded, Boolean, :default => false
    attribute :paid, Boolean, :default => false
    attribute :partially_refunded, Boolean, :default => false
    attribute :customer, 'Spree::PaymentMethod'
    attribute :amount, Float

    def cancel!
      raise Spree::IllegalOperation.new('Cannot cancel a refunded payment') if self.refunded
      raise Spree::IllegalOperation.new('Cannot cancel a canceled payment') if self.canceled
      raise Spree::IllegalOperation.new('Cannot cancel a paid payment') if self.paid
      raise Spree::IllegalOperation.new('Cannot cancel a a partially refunded payment') if self.partially_refunded

      self.canceled = true
      # TODO - potentially do something with the payment method, etc. (like void the payment on gateway)
    end

    def canceled?
      self.canceled
    end

    def refund!(amount=nil)
      raise Spree::IllegalOperation.new('Cannot refund a canceled payment') if self.canceled
      raise Spree::IllegalOperation.new('Cannot refund a canceled payment') if self.refunded

    end

    def refunded?
      self.refunded
    end

    def pay!
      raise Spree::IllegalOperation.new('Cannot pay a refunded payment') if self.refunded
      raise Spree::IllegalOperation.new('Cannot pay a canceled payment') if self.canceled
      raise Spree::IllegalOperation.new('Cannot pay a paid payment') if self.paid
      raise Spree::IllegalOperation.new('Cannot pay a partially refunded payment') if self.partially_refunded
      self.paid = true
    end

    def amount=(value)
      raise Spree::AttributeLocked.new('Amount cannot be changed') if self.amount
      super value
    end

  end
end

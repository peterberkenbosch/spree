module Spree
  class Payment < Spree::ModelBase
    include Virtus.model(finalize: false)

    attribute :canceled, Boolean, :default => false
    attribute :refunded, Boolean, :default => false
    attribute :paid, Boolean, :default => false
    attribute :partially_refunded, Boolean, :default => false
    attribute :customer, 'Spree::PaymentMethod'
    attribute :amount, Float
    attribute :refund_balance, Float, :default => 0

    def cancel
      block_states('cancel', %w(refunded canceled paid partially_refunded))
      self.canceled = true
      # TODO - do something with the payment method, etc. (like void the payment on gateway)
    end

    def refund(amount)
      block_states('refund', %w(canceled refunded))

      if amount == self.amount
        self.refunded = true
      else
        raise Spree::IllegalOperation.new('Cannot refund more than payment amount') if amount > self.amount
        raise Spree::IllegalOperation.new('Cannot refund more than refund balance on partially refunded payment') if refund_balance > 0 && amount > refund_balance

        self.partially_refunded = true
        if self.refund_balance > 0
          self.refund_balance -= amount
        else
          self.refund_balance = self.amount - amount
        end
      end
    end

    def pay
      block_states('pay', %w(refunded canceled paid partially_refunded))
      self.paid = true
    end

    def amount=(value)
      raise Spree::AttributeLocked.new('Amount cannot be changed') if self.amount
      super value
    end

  end
end

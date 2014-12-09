require 'exceptions/spree/attribute_locked'

module Spree
  class Order
    include Virtus.model(finalize: false)
    include ActiveModel::Validations

    attr_accessor :created_at

    attribute :number, String
    attribute :payments, Array['Spree::Payment']
    attribute :items, Array['Spree::Item']
    attribute :customer, 'Spree::Customer'
    attribute :canceled, Boolean, :default => false
    attribute :paid, Boolean, :default => true
    attribute :fulfilled, Boolean, :default => false
    attribute :shipped, Boolean, :default => false
    attribute :total, Float, default: 0
    attribute :item_total, Float, default: 0
    attribute :tax_total, Float, default: 0
    attribute :shipping_total, Float, default: 0

    validates_presence_of :number

    def cancel!
      raise Spree::IllegalOperation.new('Cannot cancel an order that has been fulfilled') if fulfilled?
      raise Spree::IllegalOperation.new('Cannot cancel an order that has been shipped') if shipped?

      self.canceled = true

      if self.paid?
        customer && customer.add_credit(Spree::Credit.new(:amount => self.total))
      else
        payments.each do |payment|
          payment.cancel!
        end
      end
    end

    def canceled?
      self.canceled
    end

    def fulfilled?
      self.fulfilled
    end

    def shippped?
      self.shipped
    end

    def save!
      self.created_at = Time.now
      # TODO: return serialized JSON
    end

    def payments=(payments)
      raise Spree::AttributeLocked.new('Payments cannot be changed on a saved instance') if persisted?
      super payments
    end

    def items=(items)
      raise Spree::AttributeLocked.new('Items cannot be changed on a saved instance') if persisted?
      super items
    end

    def customer=(customer)
      raise Spree::AttributeLocked.new('Customer cannot be changed on a saved instance') if persisted?
      super customer
    end

    def number=(number)
      raise Spree::AttributeLocked.new('Number cannot be changed on a saved instance') if persisted?
      super number
    end

    def total=(total)
      raise Spree::AttributeLocked.new('Total cannot be changed on a saved instance') if persisted?
      super total
    end

    def item_total=(total)
      raise Spree::AttributeLocked.new('Item total cannot be changed on a saved instance') if persisted?
      super total
    end

    def shipping_total=(total)
      raise Spree::AttributeLocked.new('Shipping total cannot be changed on a saved instance') if persisted?
      super total
    end

    def tax_total=(total)
      raise Spree::AttributeLocked.new('Tax total cannot be changed on a saved instance') if persisted?
      super total
    end

    private

    def persisted?
      self.created_at || false
    end

  end
end

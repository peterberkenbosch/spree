module Spree
  class Order < Spree::ModelBase
    include Virtus.model(finalize: false)
    include ActiveModel::Validations

    attr_accessor :created_at

    attribute :number, String
    attribute :payments, Array['Spree::Payment']
    attribute :items, Array['Spree::Item']
    attribute :customer, 'Spree::Customer'
    attribute :shipments, Array['Spree::Shipment']
    attribute :refunds, Array['Spree::Refund']
    attribute :credits, Array['Spree::Credit']
    attribute :canceled, Boolean, :default => false
    attribute :paid, Boolean, :default => true
    attribute :fulfilled, Boolean, :default => false
    attribute :shipped, Boolean, :default => false
    attribute :shipped, Boolean, :default => false
    attribute :voided, Boolean, :default => false
    attribute :total, Float, default: 0
    attribute :item_total, Float, default: 0
    attribute :tax_total, Float, default: 0
    attribute :shipping_total, Float, default: 0

    validates_presence_of :number

    def cancel
      block_states('cancel', %w(fulfilled shipped))
      self.canceled = true

      if !self.paid?
        payments.each do |payment|
          payment.cancel
        end
      end
    end

    def ship
      block_states('ship', %w(shipped))
      require_states('ship', %w(paid))

      self.shipped = true
      shipments.each { |shipment| shipment.ship }
    end

    def void
      block_states('void', %w(fulfilled shipped canceled voided))
      self.voided = true
    end

    def refund(amount=nil)
      amount ||= self.total
      require_states('refund', %w(paid))
      raise Spree::IllegalOperation.new('Cannot refund an unsaved order') if !persisted?
      raise Spree::IllegalOperation.new('Cannot refund an amount greater than total') if amount > self.total

      payment_total = 0
      refund = Spree::Refund.new(:amount => amount)

      self.payments.each do |payment|
        refund.payments << payment
        payment_total += payment.amount
        break if payment_total >= amount
      end

      self.refunds << refund
    end

    def save
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

    # Do not allow direct access to refunds collection (must use refund instead)
    def refunds=
    end

  end
end

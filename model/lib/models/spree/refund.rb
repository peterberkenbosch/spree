module Spree
  class Refund

    include Virtus.model(finalize: false)

    attribute :amount, Float, default: 0
    attribute :payments, Array['Spree::Payment']
    attribute :explanation, String
    attribute :created_at, String
    attribute :canceled, Boolean, :default => false
    attribute :approved, Boolean, :default => false
    attribute :processed, Boolean, :default => false

    def cancel!
      raise Spree::IllegalOperation.new('Cannot cancel a refund that is canceled') if canceled?
      raise Spree::IllegalOperation.new('Cannot cancel a refund that is processed') if processed?

      self.canceled = true
    end

    def approve!
      raise Spree::IllegalOperation.new('Cannot approve a refund that is approved') if approved?
      raise Spree::IllegalOperation.new('Cannot approve a refund that is canceled') if canceled?
      raise Spree::IllegalOperation.new('Cannot approve a refund that is processed') if processed?

      self.approved = true
    end

    def process!
      raise Spree::IllegalOperation.new('Cannot process a refund unless it is approved') unless approved?
      raise Spree::IllegalOperation.new('Cannot process a refund that is canceled') if canceled?
      raise Spree::IllegalOperation.new('Cannot process a refund that is processed') if processed?

      payments.each { |payment| payment.refund! }
      self.processed = true
    end

    def amount=(amount)
      raise Spree::AttributeLocked.new('Amount cannot be changed') if self.amount
      super(amount)
    end

  end
end
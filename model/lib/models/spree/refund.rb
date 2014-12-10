module Spree
  class Refund < Spree::ModelBase
    include Virtus.model(finalize: false)

    attribute :amount, Float, default: 0
    attribute :payments, Array['Spree::Payment']
    attribute :explanation, String
    attribute :created_at, String
    attribute :canceled, Boolean, :default => false
    attribute :approved, Boolean, :default => false
    attribute :processed, Boolean, :default => false

    def cancel!
      block_states('cancel!', %w(canceled processed))
      self.canceled = true
    end

    def approve!
      block_states('approve!', %w(approved canceled processed))
      self.approved = true
    end

    def process!
      block_states('process!', %w(canceled processed))
      require_states('process!', ['approved'])

      payments.each { |payment| payment.refund! }
      self.processed = true
    end

    def amount=(amount)
      raise Spree::AttributeLocked.new('Amount cannot be changed') if self.amount
      super(amount)
    end
  end
end
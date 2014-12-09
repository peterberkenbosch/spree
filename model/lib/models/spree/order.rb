require 'models/spree/payment'

module Spree
  class Order

    include Virtus.model

    attr_accessor :state
    attr_accessor :created_at

    attribute :number, String
    attribute :payments, Array[Spree::Payment]

    def cancel!
      self.state = 'canceled'
    end

    def save!
      self.created_at = Time.now
    end

    def payments=

    end

    def saved?
      !self.created_at
    end

  end
end
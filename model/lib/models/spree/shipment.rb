module Spree
  class Shipment
    include Virtus.model(finalize: false)

    attribute :shipped, Boolean, :default => false

    def ship!
      self.shipped = true
      # TODO - potentially do something with the payment method, etc. (like void the payment on gateway)
    end
  end
end
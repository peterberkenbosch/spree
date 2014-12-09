require 'models/spree/credit'

module Spree
  class Customer

    include Virtus.model

    attribute :payments, Array[Spree::Credit]
  end
end
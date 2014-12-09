module Spree
  class Address
    include Virtus.model(finalize: false)

    attribute :first_name, String
    attribute :last_name, String
    attribute :line1, String
    attribute :line2, String
    attribute :city, String
    attribute :state, String
    attribute :postal_code, String
    attribute :country, String
  end
end

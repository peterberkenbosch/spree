module Spree
  module Samples
    class CartSample

      # Get a sample [Cart] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [Cart] hash.
      def self.to_hash(options={})
        {
          billing_address: AddressSample.to_hash,
          customer: CustomerSample.to_hash,
          items: [ItemSample.to_hash],
          promotions: [PromotionSample.to_hash],
          shipping_address: AddressSample.to_hash,
          shipping_method: ShippingMethodSample.to_hash,
          shipping_rates: [ShippingRateSample.to_hash],
          token: "32452352r3wrwe13rsfsd"
        }.merge(options)
      end

    end
  end
end

module Spree
  module Samples
    class ShippingRateSample

      # Get a sample [ShippingRate] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [ShippingRate] hash.
      def self.to_hash(options={})
        {}.merge(options)
      end

    end
  end
end

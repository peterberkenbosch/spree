module Spree
  module Samples
    class ShippingMethodSample

      # Get a sample [ShippingMethod] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [ShippingMethod] hash.
      def self.to_hash(options={})
        {}.merge(options)
      end

    end
  end
end

module Spree
  module Samples
    class PaymentSample

      # Get a sample [Payment] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [Payment] hash.
      def self.to_hash(options={})
        {}.merge(options)
      end

    end
  end
end

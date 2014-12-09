module Spree
  module Samples
    class ProductSample

      # Get a sample [Product] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [Product] hash.
      def self.to_hash(options={})
        {}.merge(options)
      end

    end
  end
end

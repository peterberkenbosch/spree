module Spree
  module Samples
    class ItemSample

      # Get a sample [Item] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [Item] hash.
      def self.to_hash(options={})
        {
          variant: VariantSample.to_hash,
          quantity: 2
        }.merge(options)
      end

    end
  end
end

module Spree
  module Samples
    class VariantSample

      # Get a sample [Variant] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [Variant] hash.
      def self.to_hash(options={})
        {}.merge(options)
      end

    end
  end
end

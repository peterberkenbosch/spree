module Spree
  module Samples
    class PromotionSample

      # Get a sample [Promotion] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [Promotion] hash.
      def self.to_hash(options={})
        {}.merge(options)
      end

    end
  end
end

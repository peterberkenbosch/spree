module Spree
  module Samples
    class CustomerSample

      # Get a sample [Customer] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [Customer] hash.
      def self.to_hash(options={})
        {}.merge(options)
      end

    end
  end
end

module Spree
  module Samples
    class CreditSample

      # Get a sample [Credit] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [Credit] hash.
      def self.to_hash(options={})
        {}.merge(options)
      end

    end
  end
end

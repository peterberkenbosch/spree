module Spree
  module Samples
    class OrderSample

      # Get a sample [Order] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample Order hash.
      def self.to_hash(options={})
        {
          number: 'R1234567',
          items: [ { variant: { sku: 'ROR-123',
            product: { name: 'Ruby on Rails Tote' } },
            quantity: 2 } ]
        }.merge(options)
      end

    end
  end
end

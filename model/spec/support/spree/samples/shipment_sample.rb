module Spree
  module Samples
    class ShipmentSample

      # Get a sample [Shipment] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [Shipment] hash.
      def self.to_hash(options={})
        {}.merge(options)
      end

    end
  end
end

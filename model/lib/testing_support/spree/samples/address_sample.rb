module Spree
  module Samples
    class AddressSample

      # Get a sample [Address] hash to use in testing
      # @param options [Hash] additional hash to be merged with the default sample.
      # @return [Hash] a sample [Address] hash.
      def self.to_hash(options={})
        {
          first_name: "John",
          last_name: "Do",
          line1: "4600 East West Highway",
          line2: "Suite 800",
          city: "Bethesda",
          state: "MD",
          postal_code: "20814",
          country: "United States"
        }.merge(options)
      end

    end
  end
end

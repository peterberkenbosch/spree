require 'exceptions/spree/attribute_locked'

module Spree
  class Cart
    include Virtus.model(finalize: false)
    include ActiveModel::Validations

    attr_accessor :created_at

    attribute :billing_address, 'Spree::Address'
    attribute :customer, 'Spree::Customer'
    attribute :item_total, BigDecimal
    attribute :items, Array['Spree::Item']
    attribute :order_total, BigDecimal
    attribute :promotions, Array['Spree::Promotion']
    attribute :shipping_address, 'Spree::Address'
    attribute :shipping_method, 'Spree::ShippingMethod'
    attribute :shipping_rates, Array['Spree::ShippingRate']
    attribute :shipping_total, BigDecimal
    attribute :tax_total, BigDecimal
    attribute :token, String
    attribute :sku, String

    # Creates or updates an [Item] based upon the variant and quantity.
    #
    # Perhaps some other object should take care of building / configuring
    # the line item (tried passing a LineItem here instead but didn't feel right
    # either)
    #
    # @param variant [Variant] the variant the item is based upon.
    # @param quantity [Variant] the quantity to add of the item.
    # @param options [Hash]
    # @return an array of the carts [Item]'s.
    def add_item(variant, quantity = 1, options = {})
      raise ArgumentError unless variant.is_a?(Variant)

      if item = find_item_by_variant(variant)
        item.quantity += quantity.to_i
      else
        item = Item.new(sku: variant.sku, price: variant.price, quantity: quantity)
        self.items.push item
      end

      self.item_total = items.map(&:amount).reduce :+
      self.items
    end

    # Adds a promotion to the cart.
    #
    # @param promotion [Promotion] adds promotion to be applied to the cart's order.
    # @return an array of the carts [Promotion]'s.
    def add_promotion(promotion)
      raise ArgumentError unless promotion.is_a?(Promotion)
      self.promotions.push promotion
    end

    # Calculates each of the totals through the chain of responsibility.
    def calculate!
      raise NotImplementedError
    end

    # Resets #items to an empty [Array], and resets totals to 0.
    #
    # @return an empty array of the carts [Item]'s.
    def empty!
      self.item_total = self.order_total = self.shipping_total = self.tax_total = 0
      self.items = []
    end

    # Persists the cart to supported datastore.
    def persist!
      raise NotImplementedError
    end

    # Deletes or updates an [Item] based upon the variant and quantity.
    #
    # @param variant [Variant] the variant the item is based upon.
    # @param quantity [Variant] the quantity to remove of the item.
    # @param options [Hash]
    # @return an array of the carts [Item]'s.
    def remove_item(variant, quantity = 1, options = {})
      raise ArgumentError unless variant.is_a?(Variant)

      item = find_item_by_variant(variant)

      self.items.delete item
      self.items
    end

    # Removes a promotion from the cart.
    #
    # @param promotion [Promotion] removes promotion to not be applied to the cart's order.
    # @return an array of the carts [Promotion]'s.
    def remove_promotion(promotion)
      raise ArgumentError unless promotion.is_a?(Promotion)
      self.promotions.delete promotion
    end

    private

    # Determines if cart is persisted within a supported datastore.
    def persisted?
      self.created_at || false
    end

    # Deletes or updates an [Item] based upon the variant and quantity.
    #
    # @param variant [Variant] the variant the item is based upon.
    def find_item_by_variant(variant)
      self.items.find { |i| i.sku == variant.sku }
    end

  end
end

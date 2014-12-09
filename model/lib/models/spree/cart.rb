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

    # Perhaps some other object should take care of building / configuring
    # the line item (tried passing a LineItem here instead but didn't feel right
    # either)
    def add_item(variant, quantity = 1, options = {})
      if item = find_item_by_variant(variant)
        item.quantity += quantity.to_i
      else
        item = Item.new(sku: variant.sku, price: variant.price, quantity: quantity)
        self.items.push item
      end

      self.item_total = items.map(&:amount).reduce :+
      self.items
    end

    def remove_item(variant, quantity = 1)
      item = find_item_by_variant(variant)

      self.items.delete item
      self.items
    end

    def calculate!
      raise NotImplementedError
    end

    def empty!
      @item_total = @order_total = @shipping_total = @tax_total = 0
      @items = []
    end

    def persist!
      raise NotImplementedError
    end

    def add_promotion(promotion)
      self.promotions.push promotion
    end

    def remove_promotion(promotion)
      self.promotions.delete promotion
    end

    def empty
      self.item_total = 0
      self.items = []
    end

    private

    def persisted?
      self.created_at || false
    end

    def find_item_by_variant(variant)
      self.items.find { |i| i.sku == variant.sku }
    end

  end
end

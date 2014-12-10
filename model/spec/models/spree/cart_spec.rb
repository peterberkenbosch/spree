require 'spec_helper'

module Spree
  describe Cart do
    describe '#add_item' do
      it "adds item to cart" do
        tshirt = Variant.new price: 5, sku: 'tshirt'
        subject.add_item tshirt, 2

        expect(subject.item_total).to eq 10
        expect(subject.items.count).to eq 1
        expect(subject.items.first.quantity).to eq 2
      end

      it "adds item already in cart again" do
        tshirt = Variant.new price: 5, sku: 'tshirt'
        subject.add_item tshirt
        subject.add_item tshirt

        expect(subject.item_total).to eq 10
        expect(subject.items.count).to eq 1
        expect(subject.items.first.quantity).to eq 2
      end

      it "should raise ArgumentError for variant argument that's not Variant" do
        expect { subject.add_item(false) }.to raise_error(ArgumentError)
      end
    end

    describe '#add_promotion' do
      it "adds promotion to cart" do
        promo = Promotion.new
        subject.add_promotion promo

        expect(subject.promotions.size).to eq 1
      end

      it "should raise ArgumentError for promotion argument that's not Promotion" do
        expect { subject.add_promotion(false) }.to raise_error(ArgumentError)
      end
    end

    xit '#calulate!' do
      pending
    end

    it "#empty!" do
      tshirt = Variant.new price: 5, sku: 'tshirt'
      subject.add_item tshirt

      subject.empty!

      expect(subject.items.count).to eq 0
      expect(subject.item_total).to eq 0
      expect(subject.order_total).to eq 0
      expect(subject.shipping_total).to eq 0
      expect(subject.tax_total).to eq 0
    end

    xit '#persist!' do
      pending
    end

    describe '#remove_item' do
      it "deletes item from cart" do
        tshirt = Variant.new price: 5, sku: 'tshirt'
        subject.add_item tshirt
        subject.remove_item tshirt

        expect(subject.items.count).to eq 0
      end

      it "should raise ArgumentError for variant argument that's not Variant" do
        expect { subject.remove_item(false) }.to raise_error(ArgumentError)
      end
    end

    describe '#remove_promotion' do
      it "deletes promotion from cart" do
        promo = Promotion.new
        subject.add_promotion promo
        subject.remove_promotion promo

        expect(subject.promotions.count).to eq 0
      end

      it "should raise ArgumentError for promotion argument that's not Promotion" do
        expect { subject.add_promotion(false) }.to raise_error(ArgumentError)
      end
    end
  end
end

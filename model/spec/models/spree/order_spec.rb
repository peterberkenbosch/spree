require 'spec_helper'

describe Spree::Order do

  let(:customer) { Spree::Customer.new }
  let(:order) { Spree::Order.new }
  let(:payment) { Spree::Payment.new }
  let(:shipment) { Spree::Shipment.new }

  describe 'initializing' do

    it 'should initialize attributes & child associations' do
      order = Spree::Order.new(Spree::Samples::OrderSample.to_hash)

      expect(order.number).to eq 'R1234567'
      expect(order.items[0]).to be_an_instance_of Spree::Item
      expect(order.items.size).to eq 1
      expect(order.items[0].variant).to be_an_instance_of Spree::Variant
      expect(order.items[0].variant.sku).to eq 'ROR-123'
      expect(order.items[0].variant.product).to be_an_instance_of Spree::Product
      expect(order.items[0].variant.product.name).to eq 'Ruby on Rails Tote'
    end

  end

  describe 'validation' do

    it 'should require number' do
      expect(order.valid?).to be_falsy
      expect(order.errors.first).to eq [:number, "can't be blank"]
    end
  end

  describe '#ship!' do
    context 'when order is not yet paid' do
      let(:order) { Spree::Order.new(:paid => false, :shipments => [shipment]) }

      it 'raises' do
        expect{ order.ship! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when order is shipped' do
      let(:order) { Spree::Order.new(:shipped => true) }

      it 'raises' do
        expect{ order.ship! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when order is paid' do
      let(:order) { Spree::Order.new(:paid => true, :shipments => [shipment]) }
      before { order.ship! }

      it 'changes the state to shipped' do
        expect(order.shipped?).to eq(true)
      end

      it 'ships the shipments' do
        expect(shipment.shipped?).to eq(true)
      end
    end
  end

  describe '#void!' do
    context 'when order is not yet paid' do
      let(:order) { Spree::Order.new(:paid => false, :shipments => [shipment]) }

      before { order.void! }
      it 'changes the state to voided' do
        expect(order.voided?).to eq(true)
      end
    end

    context 'when order is canceled' do
      let(:order) { Spree::Order.new(:canceled => true) }

      it 'raises' do
        expect{ order.void! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when order is shipped' do
      let(:order) { Spree::Order.new(:shipped => true) }

      it 'raises' do
        expect{ order.void! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when order is voided' do
      let(:order) { Spree::Order.new(:voided => true) }

      it 'raises' do
        expect{ order.void! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when order is fulfilled' do
      let(:order) { Spree::Order.new(:fulfilled => true) }

      it 'raises' do
        expect{ order.void! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when order is paid' do
      let(:order) { Spree::Order.new(:paid => true) }
      before { order.void! }

      it 'changes the state to voided' do
        expect(order.voided?).to eq(true)
      end
    end
  end

  describe '#refund!' do
    let(:payment) { Spree::Payment.new(:amount => 100) }
    let(:order) { Spree::Order.new(:total => 100, :payments => [payment]) }

    context 'when store credit is requested' do
      before { order.refund!(100, true) }

      it 'creates a store credit equal to the total' do
        expects(order.credits.first.amount).to eq(100)
      end

      it 'refunds the payment' do
        expects(order.refunds.first.payments).to include(payment)
      end

      it 'the refund is for the full amount' do
        expects(order.refunds.first.amount).to eq(100)
      end
    end

    context 'when there are multiple payments' do
      let(:payment_1) { Spree::Payment.new(:amount => 25) }
      let(:payment_2) { Spree::Payment.new(:amount => 50) }

      let(:order) { Spree::Order.new(:total => 75, :payments => [payment_1, payment_2]) }

      context 'and the first payment exceeds the refund amount' do
        before { order.refund!(20, false) }

        it 'refunds the specified amount' do
          expects(order.refunds.first.amount).to eq(20)
        end

        it 'refunds the first payment' do
          expects(order.refunds.first.payments).to include(payment_1)
        end

        it 'refunds a partial amount of the first payment' do
          expects(order.refunds.first.payments[0].amount).to eq(20)
        end

        it 'does not refund the second payment' do
          expects(order.refunds.first.payments).not_to include(payment_2)
        end
      end

      context 'and the refund amount exceeds the first payment' do
        before { order.refund!(60, false) }

        it 'refunds the first payment' do
          expects(order.refunds.first.payments).to include(payment_1)
        end

        it 'refunds the specified amount' do
          expects(order.refunds.first.amount).to eq(60)
        end

        it 'refunds the full amount of the first payment' do
          expects(order.refunds.first.payments[0].amount).to eq(25)
        end

        it 'refunds the second payment' do
          expects(order.refunds.first.payments).to include(payment_2)
        end

        it 'refunds a partial amount of the second payment' do
          expects(order.refunds.first.payments[1].amount).to eq(35)
        end
      end
    end

    context 'when order has not been paid' do
      before { order.paid = false}

      it 'raises an exception' do
        expect{ order.refund!(100) }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when requested amount exceeds total' do
      it 'raises an exception' do
        expect{ order.refund!(125) }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when requested amount exceeds total of all payments' do
      let(:payment) { Spree::Payment.new(:amount => 50) }
      let(:order) { Spree::Order.new(:total => 100, :payments => [payment]) }

      it 'raises an exception' do
        expect{ order.refund!(100) }.to raise_exception(Spree::IllegalOperation)
      end
    end

  end

  describe '#cancel!' do

    context 'when order is not yet paid' do
      let(:order) { Spree::Order.new(:paid => false, :customer => customer, :payments => [payment]) }
      before { order.cancel! }

      it 'should not create any refunds' do
        expect(order.refunds.size).to eq(0)
      end

      it 'changes the state to canceled' do
        expect(order.canceled?).to eq(true)
      end

      it 'cancels the payments' do
        expect(payment.canceled?).to eq(true)
      end

    end

    context 'when order is paid' do
      let(:order) { Spree::Order.new(:paid => true, :total => 100, :customer => customer, :payments => [payment]) }
      before { order.cancel! }

      it 'changes the state to canceled' do
        expect(order.canceled?).to eq(true)
      end

      it 'does not cancel the payments' do
        expect(payment.canceled?).to eq(false)
      end
    end

    context "when order is fulfilled" do
      before { order.fulfilled = true}

      it 'raises' do
        expect{ order.cancel! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context "when order is shipped" do
      before { order.shipped = true}

      it 'raises' do
        expect{ order.cancel! }.to raise_exception(Spree::IllegalOperation)
      end
    end

  end

  describe "#save" do
    before { order.save! }

    it 'sets created_at attribute' do
      expect(order.created_at).to be()
    end
  end

  context 'when already persisted' do
    before { order.save! }

    describe '#payments=' do
      it 'raises' do
        expect{ order.payments = [] }.to raise_exception(Spree::AttributeLocked)
      end
    end

    describe '#items=' do
      it 'raises' do
        expect{ order.items = [] }.to raise_exception(Spree::AttributeLocked)
      end
    end

    describe '#cutomer=' do
      it 'raises' do
        expect{ order.customer = nil }.to raise_exception(Spree::AttributeLocked)
      end
    end

    describe "#number=" do
      it 'raises' do
        expect{ order.number = '999' }.to raise_exception(Spree::AttributeLocked)
      end
    end

    describe "#total=" do
      it 'raises' do
        expect{ order.total = '999' }.to raise_exception(Spree::AttributeLocked)
      end
    end

    describe "#item_total=" do
      it 'raises' do
        expect{ order.item_total = '999' }.to raise_exception(Spree::AttributeLocked)
      end
    end

    describe "#tax_total=" do
      it 'raises' do
        expect{ order.tax_total = '999' }.to raise_exception(Spree::AttributeLocked)
      end
    end

    describe "#shipping_total=" do
      it 'raises' do
        expect{ order.shipping_total = '999' }.to raise_exception(Spree::AttributeLocked)
      end
    end

  end

end

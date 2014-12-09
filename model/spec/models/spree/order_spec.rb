require 'spec_helper'

describe Spree::Order do

  let(:order) { Spree::Order.new }

  describe 'initializing' do

    it 'should initialize attributes & child associations' do
      order = Spree::Order.new(number: 'R1234567',
                               items: [ { variant: { sku: 'ROR-123',
                                                     product: { name: 'Ruby on Rails Tote' } },
                                          quantity: 2 } ])

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

  describe '#total' do
    it 'should supply the total returned by the chain'
  end

  describe '#cancel!' do

    before { order.cancel! }

    context 'when payment is not final' do
      let(:payment) { Spree::Payment.new(:final => false) }

      it 'should not create any credits'
    end

    context 'when the payment is final' do
      it 'creates a credit equal to the payment amount'
    end

    it 'changes the state to canceled' do
      expect(order.state).to eq('canceled')
    end

  end

  describe "#save" do
    before { order.save! }

    it 'sets created_at attribute' do
      expect(order.created_at).to be()
    end

    it 'saves the payments'
    it 'saves the customer'

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

    describe '#state=' do
      before { order.state = 'foo' }
      it 'sets the state attribute' do
        expect(order.state).to eq('foo')
      end
    end

  end

end

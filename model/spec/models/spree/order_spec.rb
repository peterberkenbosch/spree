require 'spec_helper'

describe Spree::Order do

  let(:order) { Spree::Order.new }

  describe '#total' do
    it 'should supply the total returned by the chain'
  end

  describe '#cancel!' do

    before { order.cancel! }

    context 'when payment is not final' do
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
  end

  context 'when already persisted' do
    before { order.save! }

    describe '#payments=' do
      it 'raises an exception' do
        expect{ order.payments = [] }.to raise_exception(Spree::AttributeLocked)
      end
    end

    describe '#items=' do
      it 'raises an exception' do
        expect{ order.items = [] }.to raise_exception(Spree::AttributeLocked)
      end
    end

    describe '#cutomer=' do
      it 'raises an exception' do
        expect{ order.customer = nil }.to raise_exception(Spree::AttributeLocked)
      end
    end

  end

end
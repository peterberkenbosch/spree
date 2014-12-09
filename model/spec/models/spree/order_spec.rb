require 'spec_helper'

describe Spree::Order do

  let(:customer) { Spree::Customer.new }
  let(:payment) { Spree::Payment.new }
  let(:order) { Spree::Order.new }
  #let(:order) { Spree::Order.new (:payments => [payment], :customer => customer) }

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

  describe '#save on a persisted order' do
    context 'when items have changed' do
      it 'raises an exception'
    end

    context 'when customer has changed' do
      it 'raises an exception'
    end

    context 'when payments have changed' do
      it 'raises an exception'
    end
  end

end
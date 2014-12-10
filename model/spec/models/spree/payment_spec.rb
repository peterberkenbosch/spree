require 'spec_helper'

describe Spree::Payment do
  let(:payment) { Spree::Payment.new(amount: 100) }

  describe '#cancel!' do
    context 'when unpaid' do
      subject(:payment) { Spree::Payment.new(:paid => false) }
      before { payment.cancel! }

      it 'changes the state to canceled' do
        expect(payment.canceled?).to eq(true)
      end
    end

    context 'when paid' do
      before { payment.paid = true }

      it 'raises an exception' do
        expect{ payment.cancel! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when refunded' do
      before { payment.refunded = true }

      it 'raises an exception' do
        expect{ payment.cancel! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when partially refunded' do
      before { payment.partially_refunded = true }

      it 'raises an exception' do
        expect{ payment.cancel! }.to raise_exception(Spree::IllegalOperation)
      end
    end

  end

  describe '#refund!' do
    context 'when paritally refunded' do
      before { payment.partially_refunded = true }

      context 'and amount is greater than refund balance' do
        before { payment.refund_balance = 25 }

        it 'raises an exception' do
          expect{ payment.refund! 50 }.to raise_exception(Spree::IllegalOperation)
        end
      end

      context 'and amount is less than refund balance' do
        before do
          payment.refund_balance = 75
          payment.refund! 40
        end

        it 'reduces the refund balance by the amount' do
          expect(payment.refund_balance).to eq(35)
        end
      end
    end

    context 'when paid' do
      before { payment.paid = true }

      context 'but amount is greater than payment' do
        it 'raises an exception' do
          expect{ payment.refund! 125 }.to raise_exception(Spree::IllegalOperation)
        end
      end

      context 'and no amount is specified' do
        before { payment.refund! }

        it 'refunds the entire payment' do
          expect(payment.refunded).to eq(true)
        end

        it 'has no refund balance' do
          expect(payment.refund_balance).to eq(0)
        end
      end

      context 'and amount is less than payment' do

        before { payment.refund! 25 }

        it 'partially refunds the payment' do
          expect(payment.partially_refunded).to eq(true)
        end

        it 'allocates the rest to refund_balance' do
          expect(payment.refund_balance).to eq(75)
        end
      end
    end

    context 'when canceled' do
      before { payment.canceled = true}

      it 'raises an exception' do
        expect{ payment.refund! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when refunded' do
      before { payment.refunded = true}

      it 'raises an exception' do
        expect{ payment.refund! }.to raise_exception(Spree::IllegalOperation)
      end
    end
  end

  describe '#pay!' do
    context 'when unpaid' do
      let(:payment_method) { Spree::PaymentMethod.new }
      subject(:payment) { Spree::Payment.new(paid: false, payment_method: payment_method) }
      before { payment.pay! }

      it 'sets the state to paid' do
        expect(payment.paid).to eq(true)
      end

      it 'payment method captures the payment'
    end

    context 'when paid' do
      before { payment.paid = true }

      it 'raises an exception' do
        expect{ payment.pay! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when canceled' do
      before { payment.canceled = true}

      it 'raises an exception' do
        expect{ payment.pay! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when refunded' do
      before { payment.refunded = true}

      it 'raises an exception' do
        expect{ payment.pay! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when partially refunded' do
      before { payment.partially_refunded = true}

      it 'raises an exception' do
        expect{ payment.pay! }.to raise_exception(Spree::IllegalOperation)
      end
    end
  end

  describe '#amount=' do
    context 'when the amount is already set' do
      let(:payment) { Spree::Payment.new(amount: 50) }

      it 'raises an exception' do
        expect{ payment.amount = 50 }.to raise_exception(Spree::AttributeLocked)
      end
    end
  end

end
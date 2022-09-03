require 'rails_helper'

describe ReceiveTransactionService do
  let!(:sender_account) { create :account }
  let!(:receiver_account) { create :account }
  let!(:old_amount) { receiver_account.amount }
  let(:amount) { 10.0 }
  let(:notes) { '-' }

  it 'receives money' do
    expect do
      described_class.call(
        sender_iban: sender_account.iban,
        receiver_iban: receiver_account.iban,
        amount: amount,
        notes: '-'
      )
    end.to change(Transaction, :count).by(1)

    receiver_account.reload
    expect(receiver_account.amount.to_f).to eql((old_amount + amount).to_f)

    transaction = receiver_account.transactions.last
    expect(transaction.account_id).to be(receiver_account.id)
    expect(transaction.transaction_type).to eql(Transaction::TRANSACTION_TYPE.receive)
    expect(transaction.sender_iban).to eql(sender_account.iban)
    expect(transaction.receiver_iban).to eql(receiver_account.iban)
    expect(transaction.amount.to_f).to eql(amount.to_f)
    expect(transaction.notes).to eql(notes)
  end

  context 'when there are processing errors' do
    context 'when args are missing' do
      it 'does not receive money' do
        expect do
          expect { described_class.call }.to raise_error(TransactionError, 'Missing :sender_iban')
        end.not_to change(Transaction, :count)

        receiver_account.reload
        expect(receiver_account.amount.to_f).to eql(old_amount.to_f)
      end
    end

    context 'when amount is negative' do
      it 'does not receive money' do
        expect do
          expect do
            described_class.call(
              sender_iban: sender_account.iban,
              receiver_iban: receiver_account.iban,
              amount: -amount
            )
          end.to raise_error(TransactionError, 'Receiving amount is less or equal to zero')
        end.not_to change(Transaction, :count)

        receiver_account.reload
        expect(receiver_account.amount.to_f).to eql(old_amount.to_f)
      end
    end

    context 'when sender_iban is incorrect' do
      it 'does not receive money' do
        expect do
          expect do
            described_class.call(
              sender_iban: 'fake_iban',
              receiver_iban: receiver_account.iban,
              amount: amount
            )
          end.to raise_error(TransactionError, "Can't find sender account iban=fake_iban")
        end.not_to change(Transaction, :count)

        receiver_account.reload
        expect(receiver_account.amount.to_f).to eql(old_amount.to_f)
      end
    end

    context 'when receiver_iban is incorrect' do
      it 'does not receive money' do
        expect do
          expect do
            described_class.call(
              sender_iban: sender_account.iban,
              receiver_iban: 'fake_iban',
              amount: amount
            )
          end.to raise_error(TransactionError, "Can't find receiver account iban=fake_iban")
        end.not_to change(Transaction, :count)

        receiver_account.reload
        expect(receiver_account.amount.to_f).to eql(old_amount.to_f)
      end
    end

    context 'when transaction creation failed' do
      before do
        allow(Transaction).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'does not receive money' do
        expect do
          expect do
            described_class.call(
              sender_iban: sender_account.iban,
              receiver_iban: receiver_account.iban,
              amount: amount
            )
          end.to raise_error(ActiveRecord::RecordInvalid)
        end.not_to change(Transaction, :count)

        receiver_account.reload
        expect(receiver_account.amount.to_f).to eql(old_amount.to_f)
      end
    end
  end
end

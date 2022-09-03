require 'rails_helper'

describe SendTransactionService do
  let!(:sender_account) { create :account }
  let!(:receiver_account) { create :account }
  let!(:old_amount) { sender_account.amount }
  let(:amount) { 10.0 }
  let(:notes) { '-' }

  it 'sends money' do
    expect do
      described_class.call(
        account_id: sender_account.id,
        receiver_iban: receiver_account.iban,
        amount: amount,
        notes: '-'
      )
    end.to change(Transaction, :count).by(1)

    sender_account.reload
    expect(sender_account.amount.to_f).to eql((old_amount - amount).to_f)

    transaction = sender_account.transactions.last
    expect(transaction.account_id).to be(sender_account.id)
    expect(transaction.transaction_type).to eql(Transaction::TRANSACTION_TYPE.send)
    expect(transaction.sender_iban).to eql(sender_account.iban)
    expect(transaction.receiver_iban).to eql(receiver_account.iban)
    expect(transaction.amount.to_f).to eql(amount.to_f)
    expect(transaction.notes).to eql(notes)
  end

  context 'when there are processing errors' do
    context 'when args are missing' do
      it 'does not send money' do
        expect do
          expect { described_class.call }.to raise_error(TransactionError, 'Missing :account_id')
        end.not_to change(Transaction, :count)

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(old_amount.to_f)
      end
    end

    context 'when amount is negative' do
      it 'does not send money' do
        expect do
          expect do
            described_class.call(
              account_id: sender_account.id,
              receiver_iban: receiver_account.iban,
              amount: -amount
            )
          end.to raise_error(TransactionError, 'Sending amount is less or equal to zero')
        end.not_to change(Transaction, :count)

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(old_amount.to_f)
      end
    end

    context 'when account amount is less then sending amount' do
      it 'does not send money' do
        expect do
          expect do
            described_class.call(
              account_id: sender_account.id,
              receiver_iban: receiver_account.iban,
              amount: sender_account.amount + 1.0
            )
          end.to raise_error(TransactionError, 'Sender account amount is less then sending amount')
        end.not_to change(Transaction, :count)

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(old_amount.to_f)
      end
    end

    context 'when account_id is incorrect' do
      it 'does not send money' do
        expect do
          expect do
            described_class.call(
              account_id: 'fake_id',
              receiver_iban: receiver_account.iban,
              amount: amount
            )
          end.to raise_error(TransactionError, "Can't find sender account id=fake_id")
        end.not_to change(Transaction, :count)

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(old_amount.to_f)
      end
    end

    context 'when receiver_iban is incorrect' do
      it 'does not send money' do
        expect do
          expect do
            described_class.call(
              account_id: sender_account.id,
              receiver_iban: 'fake_iban',
              amount: amount
            )
          end.to raise_error(TransactionError, "Can't find receiver account iban=fake_iban")
        end.not_to change(Transaction, :count)

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(old_amount.to_f)
      end
    end

    context 'when transaction creation failed' do
      before do
        allow(Transaction).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'does not send money' do
        expect do
          expect do
            described_class.call(
              account_id: sender_account.id,
              receiver_iban: receiver_account.iban,
              amount: amount
            )
          end.to raise_error(ActiveRecord::RecordInvalid)
        end.not_to change(Transaction, :count)

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(old_amount.to_f)
      end
    end
  end
end

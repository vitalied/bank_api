require 'rails_helper'

describe TransferService do
  let!(:sender_account) { create :account }
  let!(:receiver_account) { create :account }
  let!(:sender_old_amount) { sender_account.amount }
  let!(:receiver_old_amount) { receiver_account.amount }
  let(:amount) { 10.0 }
  let(:notes) { '-' }

  it 'sends money' do
    expect do
      described_class.call(
        account_id: sender_account.id,
        sender_iban: sender_account.iban,
        receiver_iban: receiver_account.iban,
        amount: amount,
        notes: '-'
      )
    end.to change(Transaction, :count).by(2)

    sender_account.reload
    expect(sender_account.amount.to_f).to eql((sender_old_amount - amount).to_f)

    transaction = sender_account.transactions.last
    expect(transaction.account_id).to be(sender_account.id)
    expect(transaction.transaction_type).to eql(Transaction::TRANSACTION_TYPE.send)
    expect(transaction.sender_iban).to eql(sender_account.iban)
    expect(transaction.receiver_iban).to eql(receiver_account.iban)
    expect(transaction.amount.to_f).to eql(amount.to_f)
    expect(transaction.notes).to eql(notes)
  end

  it 'receives money' do
    expect do
      described_class.call(
        account_id: sender_account.id,
        sender_iban: sender_account.iban,
        receiver_iban: receiver_account.iban,
        amount: amount,
        notes: '-'
      )
    end.to change(Transaction, :count).by(2)

    receiver_account.reload
    expect(receiver_account.amount.to_f).to eql((receiver_old_amount + amount).to_f)

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
      let(:transfer_service) { described_class.new }

      it 'does not transfer money' do
        expect { transfer_service.call }.not_to change(Transaction, :count)

        expect(transfer_service.errors).to eql(['Missing :account_id', 'Missing :sender_iban',
                                                'Missing :receiver_iban', 'Missing :amount'])

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(sender_old_amount.to_f)

        receiver_account.reload
        expect(receiver_account.amount.to_f).to eql(receiver_old_amount.to_f)
      end
    end

    context 'when amount is negative' do
      let(:transfer_service) do
        described_class.new(
          account_id: sender_account.id,
          sender_iban: sender_account.iban,
          receiver_iban: receiver_account.iban,
          amount: -amount
        )
      end

      it 'does not transfer money' do
        expect { transfer_service.call }.not_to change(Transaction, :count)

        expect(transfer_service.errors).to eql(['Sending amount is less or equal to zero'])

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(sender_old_amount.to_f)

        receiver_account.reload
        expect(receiver_account.amount.to_f).to eql(receiver_old_amount.to_f)
      end
    end

    context 'when account amount is less then sending amount' do
      let(:transfer_service) do
        described_class.new(
          account_id: sender_account.id,
          sender_iban: sender_account.iban,
          receiver_iban: receiver_account.iban,
          amount: sender_account.amount + 1.0
        )
      end

      it 'does not transfer money' do
        expect { transfer_service.call }.not_to change(Transaction, :count)

        expect(transfer_service.errors).to eql(['Sender account amount is less then sending amount'])

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(sender_old_amount.to_f)

        receiver_account.reload
        expect(receiver_account.amount.to_f).to eql(receiver_old_amount.to_f)
      end
    end

    context 'when account_id is incorrect' do
      let(:transfer_service) do
        described_class.new(
          account_id: 'fake_id',
          sender_iban: sender_account.iban,
          receiver_iban: receiver_account.iban,
          amount: amount
        )
      end

      it 'does not transfer money' do
        expect { transfer_service.call }.not_to change(Transaction, :count)

        expect(transfer_service.errors).to eql(["Can't find sender account id=fake_id"])

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(sender_old_amount.to_f)

        receiver_account.reload
        expect(receiver_account.amount.to_f).to eql(receiver_old_amount.to_f)
      end
    end

    context 'when sender_iban is incorrect' do
      let(:transfer_service) do
        described_class.new(
          account_id: sender_account.id,
          sender_iban: 'fake_iban',
          receiver_iban: receiver_account.iban,
          amount: amount
        )
      end

      it 'does not transfer money' do
        expect { transfer_service.call }.not_to change(Transaction, :count)

        expect(transfer_service.errors).to eql(["Can't find sender account iban=fake_iban"])

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(sender_old_amount.to_f)

        receiver_account.reload
        expect(receiver_account.amount.to_f).to eql(receiver_old_amount.to_f)
      end
    end

    context 'when receiver_iban is incorrect' do
      let(:transfer_service) do
        described_class.new(
          account_id: sender_account.id,
          sender_iban: sender_account.iban,
          receiver_iban: 'fake_iban',
          amount: amount
        )
      end

      it 'does not transfer money' do
        expect { transfer_service.call }.not_to change(Transaction, :count)

        expect(transfer_service.errors).to eql(["Can't find receiver account iban=fake_iban"])

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(sender_old_amount.to_f)

        receiver_account.reload
        expect(receiver_account.amount.to_f).to eql(receiver_old_amount.to_f)
      end
    end

    context 'when transaction creation failed' do
      let(:transfer_service) do
        described_class.new(
          account_id: sender_account.id,
          sender_iban: sender_account.iban,
          receiver_iban: receiver_account.iban,
          amount: amount
        )
      end

      before do
        allow(Transaction).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'does not transfer money' do
        expect { transfer_service.call }.not_to change(Transaction, :count)

        expect(transfer_service.errors).to eql(['Record invalid'])

        sender_account.reload
        expect(sender_account.amount.to_f).to eql(sender_old_amount.to_f)
      end
    end
  end
end

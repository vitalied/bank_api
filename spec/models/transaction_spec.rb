# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  account_id       :bigint           not null
#  transaction_type :string(10)       not null
#  sender_iban      :string(34)       not null
#  receiver_iban    :string(34)       not null
#  amount           :decimal(10, 2)   default(0.0), not null
#  notes            :string
#  created_by_id    :bigint
#  updated_by_id    :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_transactions_on_account_id        (account_id)
#  index_transactions_on_created_by_id     (created_by_id)
#  index_transactions_on_receiver_iban     (receiver_iban)
#  index_transactions_on_sender_iban       (sender_iban)
#  index_transactions_on_transaction_type  (transaction_type)
#  index_transactions_on_updated_by_id     (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (updated_by_id => users.id)
#
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let!(:transaction) { create :send_transaction }

  it { is_expected.to belong_to :account }
  it { is_expected.to belong_to(:created_by).class_name('User').optional }
  it { is_expected.to belong_to(:updated_by).class_name('User').optional }

  it { is_expected.to validate_presence_of(:transaction_type) }
  it { is_expected.to validate_inclusion_of(:transaction_type).in_array(Transaction::TRANSACTION_TYPES) }
  it { is_expected.to validate_presence_of(:sender_iban) }
  it { is_expected.to validate_length_of(:sender_iban).is_at_most(34) }
  it { is_expected.to validate_presence_of(:receiver_iban) }
  it { is_expected.to validate_length_of(:receiver_iban).is_at_most(34) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0.0) }

  it 'is serializable' do
    serializer = TransactionSerializer.new(transaction)
    expect(serializer.serializable_hash.keys).to eql(%i[id account_id transaction_type sender_iban receiver_iban amount
                                                        notes created_by_id updated_by_id])
  end
end

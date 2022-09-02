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
FactoryBot.define do
  factory :transaction do
    account
    amount { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    notes { nil }

    factory :send_transaction do
      transaction_type { Transaction::TRANSACTION_TYPE.send }
      sender_iban { account.iban }
      receiver_iban { Faker::Bank.unique.iban }
    end

    factory :receive_transaction do
      transaction_type { Transaction::TRANSACTION_TYPE.receive }
      sender_iban { Faker::Bank.unique.iban }
      receiver_iban { account.iban }
    end
  end
end

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
class Transaction < ApplicationRecord
  include Swaggers::TransactionModel

  belongs_to :account
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  TRANSACTION_TYPES = %w[send receive].freeze
  TRANSACTION_TYPE = Struct.new(*TRANSACTION_TYPES.map(&:to_sym)).new(*TRANSACTION_TYPES)

  validates :transaction_type, presence: true, inclusion: TRANSACTION_TYPES
  validates :sender_iban, presence: true, length: { maximum: 34 }
  validates :receiver_iban, presence: true, length: { maximum: 34 }
  validates :amount, numericality: { greater_than_or_equal_to: 0.0 }, presence: true
end

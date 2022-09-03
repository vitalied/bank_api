# == Schema Information
#
# Table name: accounts
#
#  id            :bigint           not null, primary key
#  customer_id   :bigint           not null
#  iban          :string(34)       not null
#  amount        :decimal(10, 2)   default(0.0), not null
#  created_by_id :bigint
#  updated_by_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_accounts_on_created_by_id  (created_by_id)
#  index_accounts_on_customer_id    (customer_id)
#  index_accounts_on_iban           (iban) UNIQUE
#  index_accounts_on_updated_by_id  (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (updated_by_id => users.id)
#
class Account < ApplicationRecord
  include Swaggers::AccountModel

  belongs_to :customer
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  has_many :transactions

  validates :iban, presence: true, length: { maximum: 34 }, uniqueness: true
  validates :amount, numericality: { greater_than_or_equal_to: 0.0 }, presence: true
end

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
FactoryBot.define do
  factory :account do
    customer
    iban { Faker::Bank.unique.iban }
    amount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    created_by { nil }
    updated_by { nil }
  end
end

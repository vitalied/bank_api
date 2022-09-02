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
require 'rails_helper'

RSpec.describe Account, type: :model do
  let!(:account) { create :account }

  it { is_expected.to belong_to :customer }
  it { is_expected.to belong_to(:created_by).class_name('User').optional }
  it { is_expected.to belong_to(:updated_by).class_name('User').optional }

  it { is_expected.to validate_presence_of(:iban) }
  it { is_expected.to validate_length_of(:iban).is_at_most(34) }
  it { is_expected.to validate_uniqueness_of(:iban) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0.0) }

  it 'is serializable' do
    serializer = AccountSerializer.new(account)
    expect(serializer.serializable_hash.keys).to eql(%i[id customer_id iban amount created_by_id updated_by_id])
  end
end

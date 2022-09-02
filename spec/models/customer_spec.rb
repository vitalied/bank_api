# == Schema Information
#
# Table name: customers
#
#  id         :bigint           not null, primary key
#  name       :string(100)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_customers_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Customer, type: :model do
  let!(:customer) { create :customer }

  it { is_expected.to have_many :accounts }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(100) }
  it { is_expected.to validate_uniqueness_of(:name) }

  it 'is serializable' do
    serializer = CustomerSerializer.new(customer)
    expect(serializer.serializable_hash.keys).to eql(%i[id name])
  end
end

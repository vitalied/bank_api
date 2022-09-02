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
class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name
end

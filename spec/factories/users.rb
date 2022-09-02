# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  access_token :string(40)       not null
#  username     :string(100)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_access_token  (access_token) UNIQUE
#  index_users_on_username      (username) UNIQUE
#
FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username }
  end
end

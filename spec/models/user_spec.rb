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
require 'rails_helper'

RSpec.describe User, type: :model do
  # rubocop:disable RSpec/LetSetup
  let!(:user) { create :user }
  # rubocop:enable RSpec/LetSetup

  it { is_expected.to validate_length_of(:access_token).is_at_most(40) }
  it { is_expected.to validate_uniqueness_of(:access_token) }
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_length_of(:username).is_at_most(100) }
  it { is_expected.to validate_uniqueness_of(:username) }
end

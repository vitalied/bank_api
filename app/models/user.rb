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
class User < ApplicationRecord
  validates :access_token, presence: true, length: { maximum: 40 }, uniqueness: true
  validates :username, presence: true, length: { maximum: 100 }, uniqueness: true

  before_validation :set_access_token, on: :create

  private

  def set_access_token
    self.access_token ||= SecureRandom.urlsafe_base64(30).tr('lIO0=\-_', 'sxyzEMU')
  end
end

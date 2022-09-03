class ApplicationRecord < ActiveRecord::Base
  include Swagger::Blocks
  include ModelAuthentication

  primary_abstract_class

  before_save :record_user_details

  private

  def record_user_details
    self.created_by = current_user if respond_to?(:created_by) && new_record?
    self.updated_by = current_user if respond_to?(:updated_by)
  end
end

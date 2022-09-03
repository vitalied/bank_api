module Swaggers
  module CustomerModel
    extend ActiveSupport::Concern

    included do
      swagger_schema :Customer do
        property :id do
          key :type, :integer
          key :format, :int64
        end
        property :name do
          key :type, :string
          key :maxLength, 100
          key :description, 'unique customer name'
        end
      end

      swagger_schema :CustomerCreate do
        key :required, [:name]
        property :name do
          key :type, :string
          key :maxLength, 100
          key :description, 'name must be unique'
        end
      end
    end
  end
end

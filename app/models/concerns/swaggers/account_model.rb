module Swaggers
  module AccountModel
    extend ActiveSupport::Concern

    included do
      swagger_schema :Account do
        property :id do
          key :type, :integer
          key :format, :int64
        end
        property :customer_id do
          key :type, :integer
          key :format, :int64
        end
        property :iban do
          key :type, :string
          key :maxLength, 34
        end
        property :amount do
          key :type, :number
          key :format, :decimal
          key :description, 'a number >= 0'
        end
        property :created_by_id do
          key :type, :integer
          key :format, :int64
        end
        property :updated_by_id do
          key :type, :integer
          key :format, :int64
        end
      end

      swagger_schema :AccountCreate do
        key :required, %i[iban amount]
        property :iban do
          key :type, :string
          key :maxLength, 34
          key :description, 'iban must be unique'
        end
        property :amount do
          key :type, :number
          key :format, :decimal
          key :description, 'amount must be a number >= 0'
        end
      end

      swagger_schema :AccountTransfer do
        key :required, %i[receiver_iban amount]
        property :receiver_iban do
          key :type, :string
          key :maxLength, 34
        end
        property :amount do
          key :type, :number
          key :format, :decimal
          key :description, 'amount must be a number >= 0'
        end
        property :notes do
          key :type, :string
        end
      end
    end
  end
end

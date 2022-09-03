module Swaggers
  module TransactionModel
    extend ActiveSupport::Concern

    included do
      swagger_schema :Transaction do
        property :id do
          key :type, :integer
          key :format, :int64
        end
        property :account_id do
          key :type, :integer
          key :format, :int64
        end
        property :transaction_type do
          key :type, :string
          key :maxLength, 10
          key :description, 'possible values: "send", "receive"'
        end
        property :sender_iban do
          key :type, :string
          key :maxLength, 34
        end
        property :receiver_iban do
          key :type, :string
          key :maxLength, 34
        end
        property :amount do
          key :type, :number
          key :format, :decimal
          key :description, 'a number >= 0'
        end
        property :notes do
          key :type, :string
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
    end
  end
end

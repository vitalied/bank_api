module Swaggers
  module TransactionsController
    extend ActiveSupport::Concern

    included do
      swagger_path '/customers/{customer_id}/accounts/{account_id}/transactions' do
        operation :get do
          key :tags, [:transaction]
          key :summary, 'List Transactions'
          key :description, 'Returns a list of transactions.'
          parameter Helper.customer_parameter
          parameter Helper.account_parameter

          response 200 do
            key :description, :OK
            schema do
              key :type, :array
              items do
                key :type, :object
                key :$ref, :Transaction
              end
            end
          end

          extend Swaggers::Responses::UnauthorizedError
        end
      end

      swagger_path '/customers/{customer_id}/accounts/{account_id}/transactions/{id}' do
        operation :get do
          key :tags, [:transaction]
          key :summary, 'Find Transaction by ID'
          key :description, 'Return a transaction single entity.'
          parameter Helper.customer_parameter
          parameter Helper.account_parameter
          parameter Helper.id_parameter('Transaction Id')

          response 200 do
            key :description, :OK
            schema do
              key :$ref, :Transaction
            end
          end

          extend Swaggers::Responses::UnauthorizedError

          response 404 do
            key :description, 'Not Found'
            schema do
              key :example, Helper.error_404_msg(:Transaction)
            end
          end
        end
      end
    end
  end
end

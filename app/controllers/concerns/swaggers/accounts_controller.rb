module Swaggers
  module AccountsController
    extend ActiveSupport::Concern

    included do
      swagger_path '/customers/{customer_id}/accounts' do
        operation :get do
          key :tags, [:account]
          key :summary, 'List Accounts'
          key :description, 'Returns a list of accounts.'
          parameter Helper.customer_parameter

          response 200 do
            key :description, :OK
            schema do
              key :type, :array
              items do
                key :type, :object
                key :$ref, :Account
              end
            end
          end

          extend Swaggers::Responses::UnauthorizedError
        end
      end

      swagger_path '/customers/{customer_id}/accounts/{id}' do
        operation :get do
          key :tags, [:account]
          key :summary, 'Find Account by ID'
          key :description, 'Return an account single entity.'
          parameter Helper.customer_parameter
          parameter Helper.id_parameter('Account Id')

          response 200 do
            key :description, :OK
            schema do
              key :$ref, :Account
            end
          end

          extend Swaggers::Responses::UnauthorizedError

          response 404 do
            key :description, 'Not Found'
            schema do
              key :example, Helper.error_404_msg(:Account)
            end
          end
        end
      end

      swagger_path '/customers/{customer_id}/accounts' do
        operation :post do
          key :tags, [:account]
          key :summary, 'Create Account'
          key :description, 'Create an account entity.'
          parameter Helper.customer_parameter

          parameter do
            key :name, :body
            key :in, :body
            key :description, 'Account to Create'
            schema do
              key :$ref, :AccountCreate
            end
          end

          response 201 do
            key :description, :Created
            schema do
              key :$ref, :Account
            end
          end

          extend Swaggers::Responses::UnauthorizedError
          extend Swaggers::Responses::UnprocessableEntityError
        end
      end

      swagger_path '/customers/{customer_id}/accounts/{id}/transfer' do
        operation :post do
          key :tags, [:account]
          key :summary, 'Transfer'
          key :description, 'Transfer money from an account to another.'
          parameter Helper.customer_parameter
          parameter Helper.id_parameter('Account Id')

          parameter do
            key :name, :body
            key :in, :body
            key :description, 'Transfer details'
            schema do
              key :$ref, :AccountTransfer
            end
          end

          response 201 do
            key :description, :Created
          end

          extend Swaggers::Responses::UnauthorizedError
          extend Swaggers::Responses::UnprocessableEntityError
        end
      end
    end
  end
end

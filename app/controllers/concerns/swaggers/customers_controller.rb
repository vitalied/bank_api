module Swaggers
  module CustomersController
    extend ActiveSupport::Concern

    included do
      swagger_path '/customers' do
        operation :get do
          key :tags, [:customer]
          key :summary, 'List Customers'
          key :description, 'Returns a list of customers.'

          response 200 do
            key :description, :OK
            schema do
              key :type, :array
              items do
                key :type, :object
                key :$ref, :Customer
              end
            end
          end

          extend Swaggers::Responses::UnauthorizedError
        end
      end

      swagger_path '/customers/{id}' do
        operation :get do
          key :tags, [:customer]
          key :summary, 'Find Customer by ID'
          key :description, 'Return a customer single entity.'
          parameter Helper.id_parameter('Customer Id')

          response 200 do
            key :description, :OK
            schema do
              key :$ref, :Customer
            end
          end

          extend Swaggers::Responses::UnauthorizedError

          response 404 do
            key :description, 'Not Found'
            schema do
              key :example, Helper.error_404_msg(:Customer)
            end
          end
        end
      end

      swagger_path '/customers' do
        operation :post do
          key :tags, [:customer]
          key :summary, 'Create Customer'
          key :description, 'Create a customer entity.'

          parameter do
            key :name, :body
            key :in, :body
            key :description, 'Customer to Create'
            schema do
              key :$ref, :CustomerCreate
            end
          end

          response 201 do
            key :description, :Created
            schema do
              key :$ref, :Customer
            end
          end

          extend Swaggers::Responses::UnauthorizedError
          extend Swaggers::Responses::UnprocessableEntityError
        end
      end

      swagger_path '/customers/{id}' do
        operation :put do
          key :tags, [:customer]
          key :summary, 'Update Customer'
          key :description, 'Update a customer entity.'
          parameter Helper.id_parameter('Customer Id')
          parameter do
            key :name, :body
            key :in, :body
            key :description, 'Customer to Update'
            schema do
              key :$ref, :CustomerCreate
            end
          end

          response 200 do
            key :description, :OK
            schema do
              key :$ref, :Customer
            end
          end

          extend Swaggers::Responses::UnauthorizedError

          response 404 do
            key :description, 'Not Found'
            schema do
              key :example, Helper.error_404_msg(:Customer)
            end
          end

          extend Swaggers::Responses::UnprocessableEntityError
        end
      end
    end
  end
end

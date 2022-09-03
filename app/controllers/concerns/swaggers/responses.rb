module Swaggers
  module Responses
    module UnauthorizedError
      def self.extended(base)
        base.response 401 do
          key :description, :Unauthorized
          schema do
            key :example, Helper.error_401_msg
          end
        end
      end
    end

    module ForbiddenError
      def self.extended(base)
        base.response 403 do
          key :description, :Forbidden
          schema do
            key :example, Helper.error_403_msg
          end
        end
      end
    end

    module UnprocessableEntityError
      def self.extended(base)
        base.response 422 do
          key :description, 'Unprocessable Entity'
          schema do
            key :$ref, :Errors
          end
        end
      end
    end
  end
end

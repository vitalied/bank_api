module Swaggers
  module Helper
    def self.id_parameter(description)
      { name: :id, in: :path, type: :integer, required: true, description: description }
    end

    def self.customer_parameter(required = true)
      { name: :customer_id, in: :query, type: :integer, required: required, description: 'Customer Id' }
    end

    def self.account_parameter(required = true)
      { name: :account_id, in: :query, type: :integer, required: required, description: 'Account Id' }
    end

    def self.error_400_msg(message = 'Invalid URL or method.')
      { errors: message }
    end

    def self.error_401_msg
      { errors: 'You must provide a bearer Token to use this service.' }
    end

    def self.error_403_msg
      { errors: 'You are not authorized to use this service.' }
    end

    def self.error_404_msg(model)
      { errors: "Couldn't find #{model} with 'id'=id" }
    end
  end
end

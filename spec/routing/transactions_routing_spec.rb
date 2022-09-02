require 'rails_helper'

RSpec.describe TransactionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/customers/1/accounts/2/transactions').to route_to('transactions#index',
                                                                      customer_id: '1', account_id: '2', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/customers/1/accounts/2/transactions/3').to route_to('transactions#show',
                                                                        customer_id: '1', account_id: '2', id: '3',
                                                                        format: :json)
    end
  end
end

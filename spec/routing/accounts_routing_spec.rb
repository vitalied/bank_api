require 'rails_helper'

RSpec.describe AccountsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/customers/1/accounts').to route_to('accounts#index', customer_id: '1', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/customers/1/accounts/2').to route_to('accounts#show', customer_id: '1', id: '2', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/customers/1/accounts').to route_to('accounts#create', customer_id: '1', format: :json)
    end

    it 'routes to #transfer' do
      expect(post: '/customers/1/accounts/2/transfer').to route_to('accounts#transfer',
                                                                   customer_id: '1', id: '2', format: :json)
    end
  end
end

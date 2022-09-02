require 'rails_helper'

RSpec.describe CustomersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/customers').to route_to('customers#index', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/customers/1').to route_to('customers#show', id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/customers').to route_to('customers#create', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/customers/1').to route_to('customers#update', id: '1', format: :json)
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/customers/1').to route_to('customers#update', id: '1', format: :json)
    end
  end
end

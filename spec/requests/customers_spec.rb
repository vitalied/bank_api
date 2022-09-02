require 'rails_helper'

RSpec.describe '/customers', type: :request do
  context 'unauthorized' do
    describe 'GET /customers' do
      it 'returns unauthorized status' do
        get customers_path, as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'authorized' do
    let(:user) { create :user }
    let(:token) { user.access_token }
    let!(:customer) { create :customer }
    let(:new_customer) { build :customer }
    let(:valid_params) { { name: new_customer.name } }
    let(:invalid_params) { { name: nil } }

    describe 'GET /customers' do
      before do
        get customers_path, headers: bearer_token_headers, as: :json
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns expected data' do
        expect(body.first[:id]).to be(customer.id)
      end
    end

    describe 'GET /customers/:id' do
      context 'when Customer entity exist' do
        before do
          get customer_path(customer), headers: bearer_token_headers, as: :json
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns expected data' do
          expect(body[:id]).to be(customer.id)
          expect(body_errors).not_to be_present
        end
      end

      context 'when Customer entity does not exist' do
        before do
          get customer_path(:fake_id), headers: bearer_token_headers, as: :json
        end

        it 'returns an error response' do
          expect(response).to have_http_status(:not_found)
          expect(body_errors).to be_present
        end
      end
    end

    describe 'POST /customers' do
      context 'with valid params' do
        let(:post_request) do
          post customers_path, params: valid_params, headers: bearer_token_headers, as: :json
        end

        it 'creates a new Customer entity' do
          expect { post_request }.to change(Customer, :count).by(1)
        end

        it 'renders a JSON response with the new Customer entity' do
          post_request

          expect(response).to have_http_status(:created)
          expect(body_errors).not_to be_present
          expect(response.location).to be_present

          expect(body[:name]).to eql(valid_params[:name])
        end
      end

      context 'with invalid parameters' do
        let(:post_request) do
          post customers_path, params: invalid_params, headers: bearer_token_headers, as: :json
        end

        it 'does not create a new Customer entity' do
          expect { post_request }.not_to change(Customer, :count)
        end

        it 'renders a JSON response with errors for the new entity' do
          post_request

          expect(response).to have_http_status(:unprocessable_entity)
          expect(body_errors).to be_present
        end
      end
    end

    describe 'PATCH/PUT customers/:id' do
      context 'with valid params' do
        before do
          put customer_path(customer), params: valid_params, headers: bearer_token_headers, as: :json
        end

        it 'updates the Customer entity' do
          customer.reload

          expect(customer.name).to eql(valid_params[:name])
        end

        it 'renders a JSON response with the updated Customer entity' do
          expect(response).to have_http_status(:ok)
          expect(body_errors).not_to be_present

          expect(body[:id]).to be(customer.id)
          expect(body[:name]).to eql(valid_params[:name])
        end
      end

      context 'with invalid params' do
        before do
          put customer_path(customer), params: invalid_params, headers: bearer_token_headers, as: :json
        end

        it 'renders a JSON response with errors for the Customer entity' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(body_errors).to be_present
        end
      end

      context 'when Customer entity does not exist' do
        before do
          put customer_path(:fake_id), headers: bearer_token_headers, as: :json
        end

        it 'returns a failure response containing errors' do
          expect(response).to have_http_status(:not_found)
          expect(body_errors).to be_present
        end
      end
    end
  end
end

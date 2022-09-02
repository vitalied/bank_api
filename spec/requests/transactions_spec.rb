require 'rails_helper'

RSpec.describe '/customers/:customer_id/accounts/:account_id/transactions', type: :request do
  context 'unauthorized' do
    describe 'GET /customers/:customer_id/accounts/:account_id/transactions' do
      let!(:customer) { create :customer }

      it 'returns unauthorized status' do
        get customer_accounts_path(customer), as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'authorized' do
    let(:user) { create :user }
    let(:token) { user.access_token }
    let(:customer) { create :customer }
    let(:account) { create :account, customer: customer }
    let(:other_account) { create :account, customer: customer }
    let!(:transaction) { create :send_transaction, account: account }
    let!(:other_transaction) { create :send_transaction, account: other_account }

    describe 'GET /customers/:customer_id/accounts/:account_id/transactions' do
      context 'when Customer entity exist' do
        context 'when Account entity exist' do
          before do
            get customer_account_transactions_path(customer, account), headers: bearer_token_headers, as: :json
          end

          it 'returns a success response' do
            expect(response).to have_http_status(:ok)
          end

          it 'returns expected data' do
            expect(body.size).to be(1)
            expect(body.first[:id]).to be(transaction.id)
          end
        end

        context 'when Account entity does not exist' do
          before do
            get customer_account_transactions_path(customer, :fake_id), headers: bearer_token_headers, as: :json
          end

          it 'returns an error response' do
            expect(response).to have_http_status(:not_found)
            expect(body_errors).to be_present
          end
        end
      end

      context 'when Customer entity does not exist' do
        before do
          get customer_accounts_path(:fake_id), headers: bearer_token_headers, as: :json
        end

        it 'returns an error response' do
          expect(response).to have_http_status(:not_found)
          expect(body_errors).to be_present
        end
      end
    end

    describe 'GET /customers/:customer_id/accounts/:account_id/transactions/:id' do
      context 'when Customer entity exist' do
        context 'when Account entity exist' do
          context 'when Transaction entity exist' do
            before do
              get customer_account_transaction_path(customer, account, transaction),
                  headers: bearer_token_headers, as: :json
            end

            it 'returns a success response' do
              expect(response).to have_http_status(:ok)
            end

            it 'returns expected data' do
              expect(body[:id]).to be(transaction.id)
              expect(body[:amount].to_f).to eql(transaction.amount.to_f)
              expect(body_errors).not_to be_present
            end
          end

          context 'when Transaction entity exist, but the owner is another Customer' do
            before do
              get customer_account_transaction_path(customer, account, other_transaction),
                  headers: bearer_token_headers, as: :json
            end

            it 'returns an error response' do
              expect(response).to have_http_status(:not_found)
              expect(body_errors).to be_present
            end
          end
        end

        context 'when Account entity does not exist' do
          before do
            get customer_account_transaction_path(customer, :fake_id, transaction),
                headers: bearer_token_headers, as: :json
          end

          it 'returns an error response' do
            expect(response).to have_http_status(:not_found)
            expect(body_errors).to be_present
          end
        end
      end

      context 'when Customer entity does not exist' do
        before do
          get customer_account_transaction_path(:fake_id, account, transaction),
              headers: bearer_token_headers, as: :json
        end

        it 'returns an error response' do
          expect(response).to have_http_status(:not_found)
          expect(body_errors).to be_present
        end
      end
    end
  end
end

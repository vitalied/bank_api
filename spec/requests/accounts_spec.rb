require 'rails_helper'

RSpec.describe '/customers/:customer_id/accounts', type: :request do
  context 'unauthorized' do
    describe 'GET /customers/:customer_id/accounts' do
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
    let!(:account) { create :account, customer: customer }
    let!(:other_account) { create :account }

    describe 'GET /customers/:customer_id/accounts' do
      context 'when Customer entity exist' do
        before do
          get customer_accounts_path(customer), headers: bearer_token_headers, as: :json
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns expected data' do
          expect(body.size).to be(1)
          expect(body.first[:id]).to be(account.id)
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

    describe 'GET /customers/:customer_id/accounts/:id' do
      context 'when Customer entity exist' do
        context 'when Account entity exist' do
          before do
            get customer_account_path(customer, account), headers: bearer_token_headers, as: :json
          end

          it 'returns a success response' do
            expect(response).to have_http_status(:ok)
          end

          it 'returns expected data' do
            expect(body[:id]).to be(account.id)
            expect(body[:amount].to_f).to eql(account.amount.to_f)
            expect(body_errors).not_to be_present
          end
        end

        context 'when Account entity exist, but the owner is another Customer' do
          before do
            get customer_account_path(customer, other_account), headers: bearer_token_headers, as: :json
          end

          it 'returns an error response' do
            expect(response).to have_http_status(:not_found)
            expect(body_errors).to be_present
          end
        end

        context 'when Account entity does not exist' do
          before do
            get customer_account_path(customer, :fake_id), headers: bearer_token_headers, as: :json
          end

          it 'returns an error response' do
            expect(response).to have_http_status(:not_found)
            expect(body_errors).to be_present
          end
        end
      end

      context 'when Customer entity does not exist' do
        before do
          get customer_account_path(:fake_id, account), headers: bearer_token_headers, as: :json
        end

        it 'returns an error response' do
          expect(response).to have_http_status(:not_found)
          expect(body_errors).to be_present
        end
      end
    end

    describe 'POST /customers/:customer_id/accounts' do
      let(:new_account) { build :account }
      let(:valid_params) { { customer_id: customer.id, iban: new_account.iban, amount: new_account.amount } }
      let(:invalid_params) { { iban: nil } }

      context 'when Customer entity exist' do
        context 'with valid params' do
          let(:post_request) do
            post customer_accounts_path(customer),
                 params: valid_params, headers: bearer_token_headers, as: :json
          end

          it 'creates a new Customer entity' do
            expect do
              post_request

              expect(customer.accounts.size).to be(2)
            end.to change(Account, :count).by(1)
          end

          it 'renders a JSON response with the new Account entity' do
            post_request

            expect(response).to have_http_status(:created)
            expect(body_errors).not_to be_present
            expect(response.location).to be_present

            expect(body[:customer_id]).to be(valid_params[:customer_id])
            expect(body[:iban]).to eql(valid_params[:iban])
            expect(body[:amount].to_f).to eql(valid_params[:amount].to_f)
          end
        end

        context 'with invalid parameters' do
          let(:post_request) do
            post customer_accounts_path(customer),
                 params: invalid_params, headers: bearer_token_headers, as: :json
          end

          it 'does not create a new Account entity' do
            expect { post_request }.not_to change(Account, :count)
          end

          it 'renders a JSON response with errors for the new entity' do
            post_request

            expect(response).to have_http_status(:unprocessable_entity)
            expect(body_errors).to be_present
          end
        end
      end

      context 'when Customer entity does not exist' do
        before do
          post customer_accounts_path(:fake_id),
               params: valid_params, headers: bearer_token_headers, as: :json
        end

        it 'returns an error response' do
          expect(response).to have_http_status(:not_found)
          expect(body_errors).to be_present
        end
      end
    end

    describe 'POST /customers/:customer_id/accounts/:id/transfer' do
      let(:new_transaction) { build :send_transaction }
      let(:valid_params) { { receiver_iban: new_transaction.receiver_iban, amount: new_transaction.amount } }
      let(:invalid_params) { { receiver_iban: nil } }

      context 'when Customer entity exist' do
        context 'when Account entity exist' do
          context 'with valid params' do
            let(:transfer_service) { instance_double TransferService }

            let(:post_request) do
              post transfer_customer_account_path(customer, account),
                   params: valid_params, headers: bearer_token_headers, as: :json
            end

            before do
              allow(TransferService).to receive(:new)
                .with(
                  account_id: account.id,
                  sender_iban: account.iban,
                  receiver_iban: valid_params[:receiver_iban],
                  amount: valid_params[:amount].to_s
                )
                .and_return(transfer_service)
              allow(transfer_service).to receive(:call).and_return(true)
            end

            it 'returns :created status' do
              post_request

              expect(TransferService).to have_received(:new)
              expect(transfer_service).to have_received(:call)

              expect(response).to have_http_status(:created)
            end
          end

          context 'with invalid parameters' do
            let(:transfer_service) { instance_double TransferService, errors: 'errors' }

            let(:post_request) do
              post transfer_customer_account_path(customer, account),
                   params: invalid_params, headers: bearer_token_headers, as: :json
            end

            before do
              allow(TransferService).to receive(:new)
                .with(
                  account_id: account.id,
                  sender_iban: account.iban,
                  receiver_iban: invalid_params[:receiver_iban]
                )
                .and_return(transfer_service)
              allow(transfer_service).to receive(:call).and_return(false)
            end

            it 'returns an error response' do
              post_request

              expect(TransferService).to have_received(:new)
              expect(transfer_service).to have_received(:call)

              expect(response).to have_http_status(:unprocessable_entity)
              expect(body_errors).to be_present
            end
          end
        end

        context 'when Account entity exist, but the owner is another Customer' do
          before do
            post transfer_customer_account_path(customer, other_account),
                 params: valid_params, headers: bearer_token_headers, as: :json
          end

          it 'returns an error response' do
            expect(response).to have_http_status(:not_found)
            expect(body_errors).to be_present
          end
        end

        context 'when Account entity does not exist' do
          before do
            post transfer_customer_account_path(customer, :fake_id),
                 params: valid_params, headers: bearer_token_headers, as: :json
          end

          it 'returns an error response' do
            expect(response).to have_http_status(:not_found)
            expect(body_errors).to be_present
          end
        end
      end

      context 'when Customer entity does not exist' do
        before do
          post transfer_customer_account_path(:fake_id, account),
               params: valid_params, headers: bearer_token_headers, as: :json
        end

        it 'returns an error response' do
          expect(response).to have_http_status(:not_found)
          expect(body_errors).to be_present
        end
      end
    end
  end
end

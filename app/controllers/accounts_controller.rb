class AccountsController < ApplicationController
  before_action :set_customer
  before_action :set_account, only: %i[show transfer]

  # GET /customers/:customer_id/accounts
  def index
    @accounts = @customer.accounts

    render json: @accounts
  end

  # GET /customers/:customer_id/accounts/:id
  def show
    render json: @account
  end

  # POST /customers/:customer_id/accounts
  def create
    @account = @customer.accounts.build(account_params)

    if @account.save
      render json: @account, status: :created,
             location: customer_account_path(@customer, @account)
    else
      render_errors(@account.errors)
    end
  end

  # POST /customers/:customer_id/accounts/:id/transfer
  def transfer
    transfer_service = TransferService.new(transfer_params)

    if transfer_service.call
      head :created
    else
      render_errors(transfer_service.errors)
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_account
    @account = @customer.accounts.find(params[:id])
  end

  def account_params
    params.permit(:iban, :amount)
  end

  def transfer_params
    params.permit(:receiver_iban, :amount, :notes)
          .to_h
          .merge(account_id: @account.id, sender_iban: @account.iban)
          .symbolize_keys
  end
end

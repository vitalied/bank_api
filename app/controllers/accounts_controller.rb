class AccountsController < ApplicationController
  before_action :set_customer
  before_action :set_account, only: :show

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
end

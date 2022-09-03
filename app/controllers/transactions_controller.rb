class TransactionsController < ApplicationController
  include Swaggers::TransactionsController

  before_action :set_customer
  before_action :set_account
  before_action :set_transaction, only: :show

  # GET /customers/:customer_id/accounts/:account_id/transactions
  def index
    @transactions = @account.transactions

    render json: @transactions
  end

  # GET /customers/:customer_id/accounts/:account_id/transactions/:id
  def show
    render json: @transactions
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_account
    @account = @customer.accounts.find(params[:account_id])
  end

  def set_transaction
    @transactions = @account.transactions.find(params[:id])
  end
end

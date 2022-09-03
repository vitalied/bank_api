class CustomersController < ApplicationController
  include Swaggers::CustomersController

  before_action :set_customer, only: %i[show update]

  # GET /customers
  def index
    @customers = Customer.all

    render json: @customers
  end

  # GET /customers/:id
  def show
    render json: @customer
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      render json: @customer, status: :created, location: @customer
    else
      render_errors(@customer.errors)
    end
  end

  # PATCH/PUT /customers/:id
  def update
    if @customer.update(customer_params)
      render json: @customer
    else
      render_errors(@customer.errors)
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.permit(:name)
  end
end

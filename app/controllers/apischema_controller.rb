class ApischemaController < ApplicationPublicController
  swagger_root do
    key :swagger, '2.0'

    info do
      key :version, '1.0.0'
      key :title, 'BANK API'
      key :description, ''
      contact do
        key :name, 'BANK API'
      end
    end
    tag do
      key :name, 'BANK API'
      key :description, 'Use these endpoints to manage BANK resources.'
    end
    key :host, 'localhost:3000'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  # A list of classes that have swagger_* declarations to be shown in all environments.
  PUBLIC_CLASSES = [
    self
  ].freeze

  # A list of classes that have swagger_* declarations to only be shown
  # in all environments, excepting production.
  INTERNAL_CLASSES = [
    CustomersController,
    Customer,

    AccountsController,
    Account,

    TransactionsController,
    Transaction,

    # Swagger resources
    Swaggers::Error
  ].freeze

  def all_classes
    out = PUBLIC_CLASSES
    out += INTERNAL_CLASSES unless Rails.env.production?
    out
  end

  def index
    render json: Swagger::Blocks.build_root_json(all_classes)
  end
end

class ApplicationController < ActionController::API
  include Swagger::Blocks
  include ExceptionHandling
  include Authentication
end

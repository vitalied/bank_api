class ApplicationPublicController < ActionController::API
  include Swagger::Blocks
  include ExceptionHandling
end

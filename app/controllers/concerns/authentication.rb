module Authentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  class Unauthorized < StandardError; end
  class Forbidden < StandardError; end

  included do
    before_action :authenticate_request
    before_action :store_request_level_variables

    private

    def current_user
      @current_user
    end

    def current_user_id
      @current_user&.id
    end

    def authenticate_request
      authenticate_or_request_with_http_token do |token, _options|
        @current_user = User.find_by(access_token: token)

        # To prevent time based attacks, this code can be used:
        # user_email = options[:username].presence
        # @current_user = user_email && User.find_by(email: user_email)

        ActiveSupport::SecurityUtils.secure_compare(@current_user&.access_token.to_s, token)
      end
    end

    def store_request_level_variables
      RequestStore.store[:current_user] = current_user
    end
  end
end

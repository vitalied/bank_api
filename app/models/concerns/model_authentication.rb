module ModelAuthentication
  extend ActiveSupport::Concern

  included do
    private

    def self.current_user
      RequestStore.store[:current_user]
    end

    def current_user
      RequestStore.store[:current_user]
    end

    def self.current_user_id
      RequestStore.store[:current_user]&.id
    end

    def current_user_id
      RequestStore.store[:current_user]&.id
    end
  end
end

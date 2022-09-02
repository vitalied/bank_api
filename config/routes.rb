Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  defaults format: :json do
  end

  # this needs to go last!
  match '/:anything', to: 'application_public#routing_error', constraints: { anything: /.*/ }, via: :all
end

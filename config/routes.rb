Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get ':key', to: 'application#redirect'

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      post :encode, controller: :urls
      get :decode, controller: :urls
    end
  end
end

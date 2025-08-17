# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    resources :sleep_records, only: %i[index] do
      collection do
        post :clock_in
        post :clock_out
      end
    end

    resources :follows, only: %i[create destroy]
    resources :following_sleep_records, only: %i[index]
  end
end

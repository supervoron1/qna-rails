Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :voted do
    member do
      post :like
      post :dislike
      delete :cancel
    end
  end

  resources :questions, concerns: :voted do
    resources :answers, concerns: :voted, shallow: true, only: %i[create update destroy] do
      patch :mark_as_best, on: :member
    end
  end

  resources :files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]

  mount ActionCable.server => '/cable'
end

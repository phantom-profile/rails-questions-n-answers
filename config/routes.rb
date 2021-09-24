# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'questions#index'

  resources :questions, except: :edit do
    delete :delete_attachment, on: :member
    resources :answers, shallow: true, only: %i[create destroy edit update] do
      patch :choose_best, on: :member
      delete :delete_attachment, on: :member
    end
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]
  resources :votes, only: %i[create destroy]
  resources :comments, only: %i[create new]
  resources :subscriptions, only: %i[create destroy]

  namespace 'api' do
    namespace 'v1' do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end
end

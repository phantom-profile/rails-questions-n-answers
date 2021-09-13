# frozen_string_literal: true

Rails.application.routes.draw do
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
end

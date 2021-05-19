Rails.application.routes.draw do
  devise_for :users
  resources :enrollments do 
    get :my_students, on: :collection
  end
  resources :courses do
    get :purchased, :pending_review, :created, on: :collection
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end
  resources :users, only: [:index, :edit, :show, :update]
  get 'home/index'
  get 'activity', to: 'home#activity'
  root 'home#index'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
end

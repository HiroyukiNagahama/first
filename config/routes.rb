Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help', to: 'static_pages#help'
  get  '/about', to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  resources :microposts

  namespace :api, format: 'json' do
    resources :task_api, only: [:index, :create, :update]
  end

  resources :tasks, only: [:index] do
    collection do
      get 'hoge'
    end
  end

  resources :prefectures, only: [:index] do
    collection do
      get 'edit_ajax'
      post 'update_ajax'
      post 'delete_ajax'
      get 'load_index'
    end
  end

  resources :trips, only: [:index] do
    collection do
      get 'load_index'
      patch 'update/:id', to: 'trips#update'
      post 'delete'
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

# frozen_string_literal: true

Rails.application.routes.draw do
  get '/mini' => 'pages#minimal', as: :mini
  root to: redirect('/mini', status: 302)

  get '/reading' => 'pages#reading', as: :reading
  get '/hidden' => 'pages#hidden', as: :hidden
  get '/soonest' => 'pages#soonest', as: :soonest
  get '/filter' => 'pages#filter', as: :filter
  post '/find' => 'pages#find', as: :find

  resources :pages
  resources :tags
  resources :htmls, only: ['edit']
  resources :notes, only: %w[edit show]
  resources :my_notes, only: ['edit']
  resources :end_notes, only: ['edit']
  resources :parts, only: %w[new edit create]
  resources :rates, only: %w[show create edit]
  resources :refetches, only: %w[show create]
  resources :scrubs, only: ['show']
  resources :splits, only: %w[show create]
  Tag.types.each do |type|
    resources type.pluralize.downcase.to_sym, only: %w[index show]
  end

  get '/downloads/:id.:format' => 'downloads#show', :as => 'download'
end

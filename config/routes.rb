# frozen_string_literal: true

Rails.application.routes.draw do
  get "health_check" => "application#health_check"
  root to: "repos#index"

  resources :repos, param: :name, only: [] do
    resources :pull_requests, only: :create
  end
end

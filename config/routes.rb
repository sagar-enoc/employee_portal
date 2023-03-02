# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :status do
    root to: 'health_check#index'
  end

  root to: 'status/health_check#index'
end

# config/routes.rb
Rails.application.routes.draw do
  root 'chatbot#index'
  post 'chatbot/respond', to: 'chatbot#respond'
  mount ActionCable.server => '/cable'
end

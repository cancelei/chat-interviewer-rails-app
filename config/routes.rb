Rails.application.routes.draw do

  post "chatbot/respond", to: "chatbot#respond"
  get "chatbot", to: "chatbot#index"
end

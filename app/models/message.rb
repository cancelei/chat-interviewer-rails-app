# app/models/message.rb
class Message < ApplicationRecord
  validates :content, presence: true
end

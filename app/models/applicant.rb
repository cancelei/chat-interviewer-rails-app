# app/models/applicant.rb
class Applicant < ApplicationRecord
  has_many :responses
end

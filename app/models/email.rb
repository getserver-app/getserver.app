class Email < ApplicationRecord
    validates :email, presence: true
    validates :responsibility, presence: true
end

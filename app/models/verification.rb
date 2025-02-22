class Verification < ApplicationRecord
    has_one :email
    has_one :user
    validates :path, presence: true
end

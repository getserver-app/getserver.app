class Verification < ApplicationRecord
    belongs_to :email
    belongs_to :user
    validates :path, presence: true
end

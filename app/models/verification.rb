class Verification < ApplicationRecord
    has_one :email
    has_one :user
end

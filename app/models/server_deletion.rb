class ServerDeletion < ApplicationRecord
    validates :delete_at, presence: true
    belongs_to :server
end

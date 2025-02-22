class ServerDeletion < ApplicationRecord
    validates :server_id, presence: true
    validates :delete_at, presence: true
end

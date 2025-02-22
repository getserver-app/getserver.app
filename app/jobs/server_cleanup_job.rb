class ServerCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    server_deletions = ServerDeletion.all
    server_deletions.each do |sd|
      if sd.delete_at.past?
        sd.server.destroy
      end
    end
  end
end

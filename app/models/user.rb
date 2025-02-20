class User < ApplicationRecord
  has_many :servers
  belongs_to :worker, :class_name => "Verification", :foreign_key => "email"

  validates :email, format: { with: EMAIL_REGEXP, on: :create }

  before_destroy :schedule_server_deletion

  def schedule_server_deletion
    self.servers.each do |server|
      stripe_subscription = Stripe::Subscription.retrieve(server.stripe_subscription_id)
      ServerDeletion.create({
        server_id: server.internal_id,
        delete_date: stripe_subscription.current_period_end
      })
    end
  end

  private :schedule_server_deletion
end

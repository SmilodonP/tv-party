class AddRsvpStatusToInvitations < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :rsvp_status, :integer, default: 0, null: false
  end
end

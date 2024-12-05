class RenameInviteesToInvitations < ActiveRecord::Migration[7.1]
  def change
    rename_table :invitees, :invitations
  end
end

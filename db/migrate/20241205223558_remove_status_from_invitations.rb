class RemoveStatusFromInvitations < ActiveRecord::Migration[7.1]
  def change
    remove_column :invitations, :status, :integer
  end
end

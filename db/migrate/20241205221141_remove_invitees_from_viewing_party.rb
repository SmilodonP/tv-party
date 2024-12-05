class RemoveInviteesFromViewingParty < ActiveRecord::Migration[7.1]
  def change
    remove_column :viewing_parties, :invitees, :json
  end
end

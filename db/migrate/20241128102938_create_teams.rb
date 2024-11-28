class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :team_u_name
      t.string :team_pass

      t.timestamps
    end
  end
end

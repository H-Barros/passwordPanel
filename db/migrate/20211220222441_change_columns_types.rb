class ChangeColumnsTypes < ActiveRecord::Migration[6.1]
  def change
    change_table :password_panel_dbs do |t|
      t.remove :inicioAtendimento
      t.column :inicioAtendimento, :datetime
      t.remove :finalAtendimento
      t.column :finalAtendimento, :datetime
    end
  end
end

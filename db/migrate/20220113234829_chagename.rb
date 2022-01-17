class Chagename < ActiveRecord::Migration[6.1]
  def change
    rename_column :password_panel_dbs, :inicioAtendimento, :inicio_atendimento
    rename_column :password_panel_dbs, :finalAtendimento, :final_atendimento
  end
end

class CreatePasswordPanelDbs < ActiveRecord::Migration[6.1]
  def change
    create_table :password_panel_dbs do |t|
      t.string :numero
      t.boolean :preferencial, default: false 
      t.string :setor
      t.string :servico
      t.datetime :inicioAtendimento
      t.datetime :finalAtendimento
      t.string :atendente
      t.boolean :cancelado, default: false

      t.timestamps
    end
  end
end
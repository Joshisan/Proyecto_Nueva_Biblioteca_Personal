class CreateLecturas < ActiveRecord::Migration[8.1]
  def change
    create_table :lecturas do |t|
      t.references :usuario, null: false, foreign_key: true
      t.references :libro, null: false, foreign_key: true
      t.string :estado, null: false, default: "pendiente"
      t.text :notas
      t.date :fecha_inicio
      t.date :fecha_finalizacion

      t.timestamps
    end

    add_index :lecturas, [:usuario_id, :libro_id], unique: true
  end
end

class CreateCategorias < ActiveRecord::Migration[8.1]
  def change
    create_table :categorias do |t|
      t.string :nombre, null: false
      t.text :descripcion

      t.timestamps
    end

    add_index :categorias, :nombre, unique: true
  end
end
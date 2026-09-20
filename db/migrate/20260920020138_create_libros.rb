class CreateLibros < ActiveRecord::Migration[8.1]
  def change
    create_table :libros do |t|
      t.string :isbn
      t.string :titulo, null: false
      t.string :autor, null: false
      t.references :categoria, null: false, foreign_key: true
      t.integer :anio_publicacion
      t.string :idioma
      t.string :editorial
      t.integer :unidades, null: false, default: 1

      t.timestamps
    end
  end
end

class AddActivoToLibros < ActiveRecord::Migration[8.1]
  def change
    add_column :libros, :activo, :boolean, null: false, default: true
  end
end
class AddAnioEdicionToLibros < ActiveRecord::Migration[8.1]
  def change
    add_column :libros, :anio_edicion, :integer
  end
end

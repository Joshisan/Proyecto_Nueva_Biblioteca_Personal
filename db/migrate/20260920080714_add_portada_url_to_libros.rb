class AddPortadaUrlToLibros < ActiveRecord::Migration[8.1]
  def change
    add_column :libros, :portada_url, :string
  end
end

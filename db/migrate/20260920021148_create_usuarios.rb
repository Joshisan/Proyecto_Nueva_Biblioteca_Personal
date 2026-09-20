class CreateUsuarios < ActiveRecord::Migration[8.1]
  def change
    create_table :usuarios do |t|
      t.string :nombre, null: false
      t.string :apellido, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :rol, null: false, default: "usuario"
      t.boolean :activo, null: false, default: true

      t.timestamps
    end

    add_index :usuarios, :email, unique: true
  end
end

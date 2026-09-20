require "csv"

puts "Importando categorías..."

ruta_categorias = Rails.root.join("categorias.csv")

CSV.foreach(ruta_categorias, headers: true) do |fila|
  Categoria.find_or_create_by!(nombre: fila["nombre"]) do |categoria|
    categoria.descripcion = fila["descripcion"].presence
  end
end

puts "Categorías importadas: #{Categoria.count}"

puts "Importando libros..."

ruta_libros = Rails.root.join("libros.csv")

CSV.foreach(ruta_libros, headers: true) do |fila|
  categoria = Categoria.find_by!(nombre: fila["categoria"])

  libro = Libro.find_or_initialize_by(
    titulo: fila["titulo"],
    autor: fila["autor"],
    isbn: fila["isbn"].presence
  )

  libro.assign_attributes(
    categoria: categoria,
    anio_publicacion: fila["anio_publicacion"].presence,
    anio_edicion: nil,
    idioma: fila["idioma"].presence,
    editorial: fila["editorial"].presence,
    unidades: fila["unidades"].presence || 1
  )

  libro.save!
end

puts "Libros importados: #{Libro.count}"

puts "Creando usuario administrador..."

admin_email = ENV["ADMIN_1_EMAIL"]
admin_password = ENV["ADMIN_1_PASSWORD"]

if admin_email.present? && admin_password.present?
  admin = Usuario.find_or_initialize_by(email: admin_email)

  admin.assign_attributes(
    nombre: "Administrador",
    apellido: "1",
    rol: "administrador",
    activo: true
  )

  admin.password = admin_password
  admin.password_confirmation = admin_password

  admin.save!

  puts "Administrador creado o actualizado correctamente."
else
  puts "No se creó el administrador porque faltan ADMIN_1_EMAIL o ADMIN_1_PASSWORD."
end

puts "Creando usuario demo..."

demo = Usuario.find_or_initialize_by(email: "demo@bibliotecapersonal.com")

demo.assign_attributes(
  nombre: "Usuario",
  apellido: "Demo",
  rol: "demo",
  activo: true
)

demo.password = "Demo1234"
demo.password_confirmation = "Demo1234"

demo.save!

puts "Usuario demo creado o actualizado."
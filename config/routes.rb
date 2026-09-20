Rails.application.routes.draw do
  root "inicio#index"

  # Sesión
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Registro de usuarios
  get "registro", to: "usuarios#new"
  post "registro", to: "usuarios#create"

  # Administración de usuarios
  get "administracion/usuarios",
      to: "usuarios#index",
      as: :administrar_usuarios

  get "administracion/usuarios/nuevo",
      to: "usuarios#nuevo_administrativo",
      as: :nuevo_usuario_administrativo

  post "administracion/usuarios",
      to: "usuarios#crear_administrativo",
      as: :crear_usuario_administrativo

  get "administracion/usuarios/:id/editar",
      to: "usuarios#edit",
      as: :editar_usuario

  patch "administracion/usuarios/:id",
        to: "usuarios#update",
        as: :actualizar_usuario

  patch "administracion/usuarios/:id/estado",
        to: "usuarios#cambiar_estado",
        as: :cambiar_estado_usuario

  # Catálogo
  resources :libros, only: [:index, :show, :new, :create, :edit, :update]

  get "libros-archivados",
    to: "libros#archivados",
    as: :libros_archivados

  patch "libros/:id/archivar",
      to: "libros#archivar",
      as: :archivar_libro

  patch "libros/:id/restaurar",
      to: "libros#restaurar",
      as: :restaurar_libro

  # Lecturas personales
  post "libros/:libro_id/lectura",
       to: "lecturas#create",
       as: :libro_lectura

  delete "libros/:libro_id/lectura",
       to: "lecturas#destroy",
       as: :eliminar_libro_lectura

  get "mi-biblioteca",
    to: "lecturas#index",
    as: :mi_biblioteca

  # Health check de Rails
  get "up" => "rails/health#show", as: :rails_health_check

end
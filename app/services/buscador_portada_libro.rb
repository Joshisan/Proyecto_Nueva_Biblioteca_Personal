require "net/http"
require "json"
require "uri"

class BuscadorPortadaLibro
  def initialize(libro)
    @libro = libro
  end

  def buscar
    return @libro.portada_url if @libro.portada_url.present?

    resultado = buscar_por_isbn

    unless resultado&.dig("cover_i").present?
      resultado = buscar_por_titulo_y_autor
    end

    return unless resultado&.dig("cover_i").present?

    portada_url = construir_url_portada(resultado["cover_i"])

    @libro.update!(portada_url: portada_url)

    portada_url
  end

  private

  def buscar_por_isbn
    return if @libro.isbn.blank?

    isbn = @libro.isbn.gsub(/[^0-9Xx]/, "")

    return unless [10, 13].include?(isbn.length)

    consultar_open_library(
      q: "isbn:#{isbn}"
    )
  end

  def buscar_por_titulo_y_autor
    consultar_open_library(
      title: @libro.titulo,
      author: @libro.autor
    )
  end

  def consultar_open_library(parametros)
    uri = URI("https://openlibrary.org/search.json")

    uri.query = URI.encode_www_form(
      parametros.merge(
        fields: "title,author_name,isbn,cover_i",
        limit: 5
      )
    )

    respuesta = Net::HTTP.get_response(uri)

    return unless respuesta.is_a?(Net::HTTPSuccess)

    datos = JSON.parse(respuesta.body)

    datos["docs"]&.find do |documento|
      documento["cover_i"].present?
    end
  end

  def construir_url_portada(cover_id)
    "https://covers.openlibrary.org/b/id/#{cover_id}-L.jpg"
  end
end
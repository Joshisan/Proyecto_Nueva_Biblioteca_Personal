namespace :portadas do
  desc "Busca y guarda las portadas faltantes"
  task cargar: :environment do
    libros = Libro.where(portada_url: [nil, ""]).to_a

    total = libros.size
    cola = Queue.new

    libros.each { |libro| cola << libro }

    mutex = Mutex.new
    procesados = 0
    encontrados = 0

    trabajadores = 8.times.map do
      Thread.new do
        loop do
          libro = cola.pop(true)

          begin
            portada = BuscadorPortadaLibro.new(libro).buscar

            mutex.synchronize do
              procesados += 1
              encontrados += 1 if portada.present?

              estado = portada.present? ? "OK" : "SIN PORTADA"

              puts "[#{procesados}/#{total}] #{estado} | #{libro.titulo}"
            end
          rescue ThreadError
            break
          rescue StandardError => e
            mutex.synchronize do
              procesados += 1
              puts "[#{procesados}/#{total}] ERROR | #{libro.titulo} | #{e.message}"
            end
          end
        end
      end
    end

    trabajadores.each(&:join)

    puts
    puts "=============================="
    puts "Proceso terminado"
    puts "Encontradas: #{encontrados}"
    puts "Sin portada: #{total - encontrados}"
    puts "=============================="
  end
end
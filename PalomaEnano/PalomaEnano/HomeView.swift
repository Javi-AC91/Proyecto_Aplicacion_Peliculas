import SwiftUI

struct HomeView: View {
    // Recibe el nombre del usuario desde la vista anterior
    var userName: String
    
    // Listas simples de ejemplo
    let categorias = ["Sci-Fi", "Terror", "Acción", "Comedia", "Drama", "Animación"]
    let tendencias = ["Pelicula 1", "Pelicula 2", "Pelicula 3", "Pelicula 4", "Pelicula 5"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // 1. Mensaje de saludo
                Text("¡Hola, \(userName)!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                // 2. Sección: Categorías populares
                VStack(alignment: .leading, spacing: 10) {
                    Text("Categorías populares")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    // Lista horizontal deslizable
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categorias, id: \.self) { categoria in
                                Button(action: {
                                    print("Seleccionaste la categoría: \(categoria)")
                                }) {
                                    Text(categoria)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .background(Color.pink.opacity(0.2))
                                        .foregroundColor(.pink)
                                        .bold()
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // 3. Sección: Tendencias
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tendencias")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    // Lista horizontal deslizable con tarjetas de películas
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(tendencias, id: \.self) { pelicula in
                                Button(action: {
                                    print("Seleccionaste la película: \(pelicula)")
                                }) {
                                    VStack {
                                        // Caja gris que simula el póster de la película
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 120, height: 170)
                                            .overlay(
                                                Image(systemName: "film")
                                                    .font(.system(size: 40))
                                                    .foregroundColor(.gray)
                                            )
                                        
                                        Text(pelicula)
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    HomeView(userName: "Usuario")
}

import SwiftUI

struct SecondView: View {
    @State var userName: String = ""
    
    var body: some View {
        // Envolvemos todo en NavigationStack para permitir la navegación entre pantallas
        NavigationStack {
            VStack(spacing: 40) {
                
                Text("Reseñas de Películas")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                // Campo de texto para el nombre
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 34))
                    
                    TextField("Escribe tu nombre aquí", text: $userName)
                    
                    if !userName.isEmpty {
                        Button(action: {
                            userName = ""
                        }) {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 30))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.horizontal)
                
                // Cambiamos el Button por un NavigationLink para ir a HomeView
                NavigationLink(destination: MainTabView(userName: userName)) {
                    Text("Comenzar")
                        .padding()
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                        .background(userName.isEmpty ? .gray : .blue) // Cambia a gris si está vacío
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .disabled(userName.isEmpty) // No permite avanzar si el usuario no ha escrito su nombre
                
            }
        }
    }
}

#Preview {
    SecondView()
}

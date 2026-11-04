import SwiftUI
import SwiftData

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    
    // Reemplazamos los Stores por consultas de SwiftData
    @Environment(\.modelContext) private var context
    @Query private var allFavorites: [Movie]
    @Query private var allReviews: [Review]
    
    init(movie: Movie) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movie: movie))
    }
    
    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: viewModel.movie.posterURL) { $0.resizable().scaledToFit() } placeholder: {
                        Color.gray.opacity(0.3).frame(height: 300)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text(viewModel.movie.title).font(.title.bold())
                    Text("Estreno: \(viewModel.movie.releaseDate ?? "N/D")").font(.subheadline)
                    Text(viewModel.movie.overview.isEmpty ? "Sin sinopsis disponible." : viewModel.movie.overview)
                    
                    Divider().padding(.vertical, 8)
                    
                    HStack {
                        Text("Mi Reseña").font(.title3.bold())
                        Spacer()
                        Button(viewModel.myReview(reviews: allReviews) == nil ? "Escribir" : "Editar") {
                            viewModel.showReviewForm = true
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    if let review = viewModel.myReview(reviews: allReviews) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "star.fill").foregroundColor(.yellow)
                                Text("\(review.rating) / 10").bold()
                                Spacer()
                                Text(review.date, style: .date).font(.caption).foregroundColor(.secondary)
                            }
                            Text(review.comment).font(.body)
                        }
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                viewModel.toggleFavorite(in: context, favorites: allFavorites)
            } label: {
                Image(systemName: viewModel.isFavorite(favorites: allFavorites) ? "heart.fill" : "heart")
            }
        }
        .sheet(isPresented: $viewModel.showReviewForm) {
            ReviewFormView(movieId: viewModel.movie.id, existingReview: viewModel.myReview(reviews: allReviews))
        }
    }
}

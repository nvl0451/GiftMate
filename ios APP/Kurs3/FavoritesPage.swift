import Foundation
import SwiftUI

struct FavoritesPage: View {
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(favoritesViewModel.favorites, id: \.id) { favorite in
                    favoriteCard(for: favorite)
                }
            }
            .padding()
        }
        .navigationTitle("Избранное")
    }

    @ViewBuilder
    private func favoriteCard(for favorite: FavoriteItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(favorite.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let url = favorite.url {
                    Link(destination: url) {
                        Text("Подробнее")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteItem] = []
    
    func addFavorite(_ name: String, url: URL?) {
        let newItem = FavoriteItem(name: name, url: url)
        favorites.append(newItem)
    }
}

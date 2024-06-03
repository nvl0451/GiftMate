import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteItemModel] = []
    
    func addFavorite(_ name: String, url: URL?) {
        let newItem = FavoriteItemModel(name: name, url: url)
        favorites.append(newItem)
    }
}

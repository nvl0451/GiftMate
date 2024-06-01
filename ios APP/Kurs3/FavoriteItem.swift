import Foundation

struct FavoriteItem: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let url: URL?
}

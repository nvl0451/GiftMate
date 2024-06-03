import Foundation

struct FavoriteItemModel: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let url: URL?
}

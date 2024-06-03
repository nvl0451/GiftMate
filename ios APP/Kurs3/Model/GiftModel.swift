import Foundation

struct GiftModel: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let url: URL?
}

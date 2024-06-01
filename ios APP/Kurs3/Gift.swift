import Foundation

struct Gift: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let url: URL?
}

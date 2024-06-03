import SwiftUI

struct GiftsListView: View {
    var gifts: [GiftModel]
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    var body: some View {
        VStack {
            Text("Идеи подарков")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)

            List(gifts, id: \.self) { gift in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Link(destination: gift.url ?? URL(string: "https://example.com")!) {
                            Text(gift.name)
                                .foregroundColor(.blue)
                                .underline()
                        }
                        .padding(.vertical, 10)
                    }
                    Spacer()
                    Button(action: {
                        favoritesViewModel.addFavorite(gift.name, url: gift.url)
                    }) {
                        Image(systemName: favoritesViewModel.isFavorite(gift: gift) ? "star.fill" : "star")
                            .foregroundColor(favoritesViewModel.isFavorite(gift: gift) ? .yellow : .gray)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.vertical, 5)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
            }
            .listStyle(PlainListStyle())
        }
        .padding(.horizontal)
        .background(Color(UIColor.systemGroupedBackground))
    }
}

extension FavoritesViewModel {
    func isFavorite(gift: GiftModel) -> Bool {
        return favorites.contains(where: { $0.name == gift.name && $0.url == gift.url })
    }
}

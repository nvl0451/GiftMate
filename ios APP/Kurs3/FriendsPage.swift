import Foundation
import SwiftUI

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let interests: String
    let social: String
}

struct FriendsPage: View {
    @State private var searchQuery = ""
    @State private var friends: [Friend] = [
        Friend(name: "Алексей", interests: "Программирование, Кино", social: "Twitter"),
        Friend(name: "Марина", interests: "Искусство, Путешествия", social: "Instagram"),
        Friend(name: "Иван", interests: "Спорт, Книги", social: "Facebook"),
    ]
    @ObservedObject var viewModel = HomePageViewModel()

    var body: some View {
        NavigationView {
            List {
                TextField("Поиск...", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                ForEach(friends.filter { $0.name.contains(searchQuery) || searchQuery.isEmpty }) { friend in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(friend.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(friend.interests)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.fetchGiftIdeas(interests: friend.interests, socialNetworks: friend.social)
                            }) {
                                Label("Интересы", systemImage: "gift.fill")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                    .shadow(radius: 1)
                    .padding(.horizontal)
                }
            }
            .navigationBarTitle("Друзья")
            .listStyle(PlainListStyle())
        }
    }
}

struct FriendsPage_Previews: PreviewProvider {
    static var previews: some View {
        FriendsPage()
    }
}

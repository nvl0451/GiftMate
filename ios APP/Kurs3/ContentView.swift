import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomePage()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Главная")
                }

            FriendsPage()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Друзья")
                }

            FavoritesPage()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Избранное")
                }

            ProfilePage()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Профиль")
                }
        }
    }
}

#Preview {
    ContentView()
}

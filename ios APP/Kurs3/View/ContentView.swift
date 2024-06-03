import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomePageView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Главная")
                }

            FriendsPageView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Друзья")
                }

            FavoritesPageView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Избранное")
                }

            ProfilePageView()
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

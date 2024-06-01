import SwiftUI

@main
struct Kurs3App: App {
    @StateObject private var authViewModel = AuthViewModel()
    var favoritesViewModel = FavoritesViewModel()
    
    var body: some Scene {
            WindowGroup {
                if authViewModel.isUserAuthenticated {
                    ContentView().environmentObject(favoritesViewModel)
                } else {
                    AuthView()
                }
            }
        }
}

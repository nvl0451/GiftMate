import Foundation

import Foundation

class AuthViewModel: ObservableObject {
    @Published var isUserAuthenticated: Bool = UserDefaults.standard.string(forKey: "userToken") != nil
    @Published var alertMessage: String = ""
    @Published var isShowingAlert: Bool = false

    func loginUser(email: String, password: String) {
        guard let loginURL = URL(string: "http://127.0.0.1:5000/login") else { return }
        AuthService.shared.performAuthRequest(url: loginURL, email: email, password: password) { success, result in
            DispatchQueue.main.async {
                if success {
                    UserDefaults.standard.set(result, forKey: "userToken")
                    self.isUserAuthenticated = true
                } else {
                    // Показать ошибку пользователю
                    self.alertMessage = result
                    self.isShowingAlert = true
                }
            }
        }
    }

    func registerUser(email: String, login: String, password: String) {
        guard let registerURL = URL(string: "http://127.0.0.1:5000/register") else { return }
        AuthService.shared.performRegistrationRequest(url: registerURL, login: login, email: email, password: password) { success, result in
            DispatchQueue.main.async {
                if success {
                    UserDefaults.standard.set(result, forKey: "userToken")
                    self.isUserAuthenticated = true
                } else {
                    
                    self.alertMessage = result
                    self.isShowingAlert = true
                }
            }
        }
    }
}

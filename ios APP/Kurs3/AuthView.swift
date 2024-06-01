import SwiftUI

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                }) {
                    Text("Войти")
                }
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("Авторизация"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Авторизация", displayMode: .inline)
        }
    }
    
    func authenticateUser(email: String, password: String) {
        guard let url = URL(string: "http://yourserver.com/login") else { return }
        let body: [String: String] = ["email": email, "password": password]
        let finalBody = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.alertMessage = "No data in response: \(error?.localizedDescription ?? "Unknown error")."
                    self.isShowingAlert = true
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.alertMessage = decodedResponse?.message ?? "An unknown error occurred"
                        self.isShowingAlert = true
                    }
                }
            }
        }.resume()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}

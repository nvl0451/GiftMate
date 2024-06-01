import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var login = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            TextField("Login", text: $login)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Зарегистрироваться") {
                viewModel.registerUser(email: email, login: login, password: password)
            }
            .alert(isPresented: $viewModel.isShowingAlert) {
                Alert(title: Text("Регистрация"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarTitle("Регистрация", displayMode: .inline)
    }
}

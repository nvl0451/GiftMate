import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Войти") {
                viewModel.loginUser(email: email, password: password)
            }
            .alert(isPresented: $viewModel.isShowingAlert) {
                Alert(title: Text("Вход"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }

        }
        .navigationBarTitle("Вход", displayMode: .inline)
    }
}

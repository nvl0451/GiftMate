import SwiftUI

struct ProfilePage: View {
    @State private var name: String = ""
    @State private var birthDate = Date()
    @State private var interests: String = ""
    @State private var profileImage: UIImage? = nil
    @State private var isImagePickerDisplay = false
    @State private var isDarkModeEnabled = false
    @State private var notificationsEnabled = true

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 4)
                        .foregroundColor(.blue)
                        .frame(width: 120, height: 120)
                    
                    Image(uiImage: profileImage ?? UIImage(systemName: "person.crop.circle")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .onTapGesture {
                            self.isImagePickerDisplay = true
                        }
                }
                .padding(.top, 20)

                GroupBox(label: Label("Основная информация", systemImage: "person.fill")) {
                    TextField("Имя", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    DatePicker("Дата рождения", selection: $birthDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    
                    TextField("Интересы", text: $interests)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .groupBoxStyle(PreferencesGroupBoxStyle())

                GroupBox(label: Label("Настройки", systemImage: "gear")) {
                    Toggle(isOn: $isDarkModeEnabled) {
                        Text("Тёмная тема")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Уведомления")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                .groupBoxStyle(PreferencesGroupBoxStyle())

                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$profileImage, sourceType: .photoLibrary)
        }
        .navigationTitle("Профиль")
        .background(isDarkModeEnabled ? Color.black : Color.white)
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
    }
}

struct PreferencesGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            configuration.label
                .font(.headline)
                .padding(.bottom, 5)
            
            configuration.content
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}

import SwiftUI

struct HomePage: View {
    @StateObject private var viewModel = HomePageViewModel()
    @State private var interests = ""
    @State private var socialNetworks = ""
    @State private var showGiftsListView = false

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .padding(.top)
            
            Text("Поиск идеального подарка")
                .font(.title)
                .padding()
            
            TextField("Введите интересы", text: $interests)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Социальные сети (необязательно)", text: $socialNetworks)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Подобрать") {
                viewModel.fetchGiftIdeas(interests: interests, socialNetworks: socialNetworks)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom)
            
            if viewModel.isLoading {
                ProgressView("Загрузка...")
            }
            
            if viewModel.selectedGifts?.isEmpty == false {
                Button("Показать подарки") {
                    showGiftsListView = true
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Поиск подарков")
        
        .sheet(isPresented: $showGiftsListView) {
            
            let giftObjects = viewModel.selectedGifts?.map { Gift(name: $0, url: URL(string: "https://market.yandex.ru/search?text=" + $0)) } ?? []
            GiftsListView(gifts: giftObjects)
        }

    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

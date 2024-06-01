import Foundation

class HomePageViewModel: ObservableObject {
    @Published var gifts: [String] = []
    @Published var isLoading = false
    @Published var selectedGifts: [String]? = nil

    func fetchGiftIdeas(interests: String, socialNetworks: String) {
        self.isLoading = true
        guard let url = URL(string: "http://127.0.0.1:5000/get_ideas") else {
            print("Некорректный URL.")
            return
        }
        
        let requestBody = ["interests": interests, "social_networks": socialNetworks]
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            guard let data = data, error == nil else {
                print("Ошибка сетевого запроса: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decodedResponse = try JSONDecoder().decode(GiftIdeasResponse.self, from: data)
                    print(decodedResponse)
                    let giftsList = decodedResponse.ans
                    DispatchQueue.main.async {
                        self.gifts = giftsList.components(separatedBy: "\n").filter { !$0.isEmpty }
                        self.selectedGifts = self.gifts // Активируем навигацию
                    }
                } catch {
                    print("Ошибка декодирования: \(error)")
                }
            } else {
                print("Сервер вернул ошибку.")
            }
        }.resume()
    }
}

import Foundation

func performAuthRequest(url: URL, email: String, password: String, completion: @escaping (Bool, String) -> Void) {
    let body: [String: String] = ["email": email, "password": password]
    guard let finalBody = try? JSONSerialization.data(withJSONObject: body) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = finalBody
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            DispatchQueue.main.async {
                completion(false, "Network request failed")
            }
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                // Пример обработки JWT токена
                if let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data),
                   let token = decodedResponse.token {
                    DispatchQueue.main.async {
                        completion(true, token)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        completion(false, "Failed to decode response")
                    }
                }
            } else {
                // Обработка сообщения об ошибке от сервера
                if let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data),
                   let message = decodedResponse.message {
                    DispatchQueue.main.async {
                        completion(false, message)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, "An unknown error occurred")
                    }
                }
            }
        }
    }.resume()
}

func performRegistrationRequest(url: URL, login: String, email: String, password: String, completion: @escaping (Bool, String) -> Void) {
    let body: [String: String] = ["login": login, "email": email, "password": password]
    guard let finalBody = try? JSONSerialization.data(withJSONObject: body) else {
        DispatchQueue.main.async {
            completion(false, "Error creating request data")
        }
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = finalBody
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            DispatchQueue.main.async {
                completion(false, "Network request failed: \(error?.localizedDescription ?? "Unknown error")")
            }
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...299:
                let decodedResponse = try? JSONDecoder().decode(RegistrationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(true, decodedResponse?.message ?? "Registration successful")
                }
            default:
                let decodedResponse = try? JSONDecoder().decode(RegistrationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(false, decodedResponse?.message ?? "Registration failed")
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false, "Invalid response from server")
            }
        }
    }.resume()
}

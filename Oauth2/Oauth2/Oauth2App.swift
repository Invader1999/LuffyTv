import SwiftUI

@main
struct OAuth2App: App {
    @StateObject var testViewModel = TestingViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(testViewModel)
                .onOpenURL(perform: { url in
                    handleRedirectURL(url: url)
                })
        }
    }
    
    // Handle the redirect URL
    func handleRedirectURL(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            print("Invalid redirect URL")
            return
        }
        
        if let code = queryItems.first(where: { $0.name == "code" })?.value {
            exchangeAuthorizationCodeForTokens(authorizationCode: code)
            print("Authorization Code:", code)
        }
    }
    
    
    // Exchange authorization code for tokens
    func exchangeAuthorizationCodeForTokens(authorizationCode: String) {
        let clientId = "5274891a3e0d34914d1cc7f5376a59e5"
        let redirectUri = "https://com.hemanth"
        guard let codeVerifier = testViewModel.codeVerifier else {
            print("Error: Missing code verifier")
            return
        }
        
        let url = URL(string: "https://myanimelist.net/v1/oauth2/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Construct request body
        var requestBody = [
            "client_id": clientId,
            "grant_type": "authorization_code",
            "code": authorizationCode,
            "redirect_uri": redirectUri,
            "code_verifier": codeVerifier,
            "state": testViewModel.state
        ]
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        request.httpBody = requestBody.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle network errors
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            // Handle HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: No HTTP response")
                return
            }
            
            // Handle HTTP status codes
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP Error: \(httpResponse.statusCode)")
                if let data = data {
                    print("Response Data:", String(data: data, encoding: .utf8) ?? "")
                }
                return
            }
            
            // Handle successful response
            guard let data = data else {
                print("Error: No data received")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Unable to parse JSON response")
                    return
                }
                
                // Handle access token and refresh token
                guard let accessToken = json["access_token"] as? String, let refreshToken = json["refresh_token"] as? String else {
                    print("Error: Missing access or refresh token in response")
                    return
                }
                
                print("Access Token:", accessToken)
                print("Refresh Token:", refreshToken)
                
            } catch {
                print("Error parsing JSON:", error)
            }
        }
        
        task.resume()
    }
    
    
    
}


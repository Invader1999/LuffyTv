import SwiftUI
import CryptoKit
import AuthenticationServices


struct ContentView: View {
    @EnvironmentObject var testViewModel: TestingViewModel
    
    var body: some View {
        Button("Authorize") {
            AuthenticationServicesLogin()
        }
    }
    
    // Perform the authentication
    private func AuthenticationServicesLogin() {
        // Generate a code verifier and challenge
        let codeVerifier = generateCodeVerifier()
        let codeChallenge = generateCodeChallenge(from: codeVerifier)
        
        // Store the code verifier in the view model
        testViewModel.codeVerifier = codeVerifier
        
        // Create the authorization URL
        let authorizationURL = createAuthorizationURL(codeChallenge: codeChallenge)
        
        // Open the authorization URL
        openAuthorizationURL(url: authorizationURL)
    }
    
    // Generate a random code verifier
    private func generateCodeVerifier() -> String {
        let verifierData = Data((0..<128).map { _ in UInt8.random(in: 0...255) })
        let finalData = verifierData.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        print(finalData, "Code Verifier is")
        return finalData
    }
    
    // Generate code challenge from code verifier
    private func generateCodeChallenge(from verifier: String) -> String {
        guard let verifierData = verifier.data(using: .utf8) else { return "" }
        let hash = SHA256.hash(data: verifierData)
        let finalData = Data(hash).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return finalData
    }
    
    func getState()->String{
        let state = UUID().uuidString
        testViewModel.state = state
        return state
    }
    
    // Create the authorization URL
    private func createAuthorizationURL(codeChallenge: String) -> URL {
        let baseURL = "https://myanimelist.net/v1/oauth2/authorize"
        let queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            //URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "client_id", value: "5274891a3e0d34914d1cc7f5376a59e5"),
            URLQueryItem(name: "redirect_uri", value: "https://com.hemanth"),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "plain"),
            URLQueryItem(name: "state", value: getState())
            
        ]
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = queryItems
        
        return components.url!
    }
    
    // Open the authorization URL
    private func openAuthorizationURL(url: URL) {
        UIApplication.shared.open(url)
    }
}

class TestingViewModel: ObservableObject {
    @Published var codeVerifier: String?
    @Published var state: String?
}


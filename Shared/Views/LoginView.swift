//
//  LoginView.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/12/23.
//

import SwiftUI
import WebKit

struct LoginView: View {
    @State private var webViewNavigation = WebViewNavigation()
    @AppStorage("id") private var user_id = ""
    @Binding var presented: Bool
    @Binding var user: MSUUser
    
    var body: some View {
        WebView(urlString: Constants.DISCORD_AUTH_URL, navigation: $webViewNavigation, onDismiss: {}).onChange(of: webViewNavigation.redirectURL, {
            presented = false
            Task {
                let code = (webViewNavigation.redirectURL?.valueOf("code")) ?? ""
                let user = try await MSUService.login(code: code)
                if let user = user {
                    user_id = user.id
                    self.user = user
                }
            }
        })
    }
    
    // WebView component
    struct WebView: UIViewRepresentable {
        let urlString: String
        @Binding var navigation: WebViewNavigation
        var onDismiss: (() -> Void)? = nil
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            webView.navigationDelegate = context.coordinator
            webView.load(URLRequest(url: URL(string: urlString)!))
            return webView
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {}
        
        class Coordinator: NSObject, WKNavigationDelegate {
            var parent: WebView
            
            init(_ parent: WebView) {
                self.parent = parent
            }
            
            // Capture the redirect URL when the web view navigates to it
            func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
                if let url = navigationAction.request.url {
                    if(url.absoluteString.starts(with: Constants.DISCORD_REDIRECT_URL)){
                        parent.navigation.redirectURL = url
                    }
                }
                decisionHandler(.allow)
            }
            
            // Handle web view dismissal
            func webViewDidClose(_ webView: WKWebView) {
                parent.onDismiss?()
            }
        }
    }
    
    // Model to track navigation state
    struct WebViewNavigation {
        var didCommit = false
        var didFinish = false
        var redirectURL: URL?
    }
}

// Extension to extract query parameters from URL
extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = urlComponents.queryItems else {
            return nil
        }
        
        return queryItems.first(where: { $0.name == queryParameterName })?.value
    }
}

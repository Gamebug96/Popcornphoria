//
//  WebView.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 21/04/24.
//

import SwiftUI
import WebKit

struct WebView: View {
   enum WebContent {
      case tokenValidation
   }

   let url: URL
   let content: WebContent
   var completion: (() -> Void)?

   @State private var isLoading = false

   var body: some View {
      WebContentView(
         url: url,
         content: content,
         isLoading: $isLoading,
         completion: completion
      )
      .background(.black)
      .ignoresSafeArea()
   }
}

struct WebContentView: UIViewRepresentable {
   let url: URL
   let content: WebView.WebContent
   @Binding var isLoading: Bool
   var completion: (() -> Void)?

   func makeUIView(context: Context) -> WKWebView  {
      let wkwebView = WKWebView()
      wkwebView.navigationDelegate = context.coordinator
      wkwebView.load(.init(url: url))
      return wkwebView
   }

   func updateUIView(_ uiView: WKWebView, context: Context) {
   }

   func makeCoordinator() -> Coordinator {
      Coordinator(self)
   }

   final class Coordinator: NSObject, WKNavigationDelegate {
      var parent: WebContentView

      init(_ parent: WebContentView) {
         self.parent = parent
      }

      func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         switch parent.content {
         case .tokenValidation:
            parent.isLoading = true
         }
      }

      func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         parent.isLoading = false
         if
            parent.content == .tokenValidation,
            (webView.url?.absoluteString ?? "").contains("allow") {
            parent.completion?()
         }
      }
   }
}

//
//  ProfileView.swift
//  Beri
//
//  Created by Telmen Bayarbaatar on 8/12/25.
//

import SwiftUI
import StoreKit

struct ProfileView: View {
    @State private var showAuthAlert: Bool = false
    @Environment(\.openURL) private var openURL

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        return [version, build].filter { !$0.isEmpty }.joined(separator: " (" ) + (!build.isEmpty ? ")" : "")
    }

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Account")) {
                    Button("Sign in / Create account") { showAuthAlert = true }
                    Button("Request account deletion") { showAuthAlert = true }
                        .foregroundColor(.red)
                }

                Section(header: Text("Support")) {
                    Button {
                        openMail("support@example.com", subject: "Beri Support")
                    } label: { Label("Contact support", systemImage: "envelope") }

                    Button {
                        openMail("support@example.com", subject: "Beri Bug Report")
                    } label: { Label("Report a bug", systemImage: "ladybug") }
                }

                Section(header: Text("Legal")) {
                    NavigationLink(value: LegalRoute.privacy) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    NavigationLink(value: LegalRoute.terms) {
                        Label("Terms of Use", systemImage: "doc.text")
                    }
                }

                Section(header: Text("About")) {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text(appVersion).foregroundStyle(.secondary)
                    }
                    Button {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    } label: { Label("Rate Beri", systemImage: "star") }

                    if let url = URL(string: "https://beri.example.com") {
                        ShareLink(item: url) { Label("Share Beri", systemImage: "square.and.arrow.up") }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationDestination(for: LegalRoute.self) { route in
                switch route {
                case .privacy:
                    LegalDocumentView(title: "Privacy Policy", markdown: privacyMarkdown)
                case .terms:
                    LegalDocumentView(title: "Terms of Use", markdown: termsMarkdown)
                }
            }
            .tint(Palette.primary)
            .listStyle(.insetGrouped)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden, edges: .all)
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemBackground))
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: ArtisticTabBar.height + 8) }
        }
        .alert("Coming soon", isPresented: $showAuthAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Authentication flows will be added next. Account deletion will be available after sign‑in, as required by App Store guidelines.")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
    }

    private func openMail(_ address: String, subject: String) {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "mailto:\\(address)?subject=\\(subjectEncoded)"
        if let url = URL(string: urlString) { openURL(url) }
    }
}

private enum LegalRoute: Hashable { case privacy, terms }

private struct LegalDocumentView: View {
    let title: String
    let markdown: String
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(.init(markdown))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            .padding(.bottom, ArtisticTabBar.height + 8)
        }
        .navigationTitle(title)
        .background(Color(UIColor.systemBackground))
    }
}

// Minimal in-app legal copy to satisfy App Store review visibility. Replace with your full policy text/links.
private let privacyMarkdown: String = """
**Privacy Policy**\n\n
We value your privacy. Beri does not collect personal information unless you sign in. Any data you choose to create (like widget content) is stored on your device and, if you opt in, may sync via your Apple services.\n\n
If you create an account later, you will be able to delete your account and associated data from within the app. For questions, contact support@example.com.
"""

private let termsMarkdown: String = """
**Terms of Use**\n\n
By using Beri you agree to use the app responsibly and comply with applicable laws. Content you create is your responsibility. The app is provided “as is” without warranties of any kind to the maximum extent permitted by law.\n\n
If you create an account later, additional terms will apply and you will be able to delete your account from within the app.
"""

#Preview { ProfileView() }

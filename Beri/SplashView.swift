//
//  SplashView.swift
//  Beri
//
//  Created by Assistant on 8/17/25.
//

import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .shadow(radius: 12)

                Text("Beri")
                    .font(.system(size: 34, weight: .bold))
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            withAnimation(.easeInOut) {
                isActive = true
            }
        }
    }
}

#Preview {
    @Previewable @State var isActive: Bool = false
    return SplashView(isActive: $isActive)
}



//
//  LoadingOverlay.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/6/25.
//

import SwiftUI

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Fetching Recipes...")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .transition(.opacity)
    }
}

#Preview {
    LoadingOverlay()
}

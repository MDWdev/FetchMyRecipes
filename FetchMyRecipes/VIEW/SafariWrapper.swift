//
//  SafariWrapper.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/6/25.
//

import SwiftUI
import SafariServices

struct SafariWrapper: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

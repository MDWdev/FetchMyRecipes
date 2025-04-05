//
//  String+Extended.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/4/25.
//

import Foundation
import CryptoKit

extension String {
    func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

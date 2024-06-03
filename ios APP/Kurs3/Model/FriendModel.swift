//
//  FriendModel.swift
//  Kurs3
//
//  Created by Андрей Королев on 03.06.2024.
//

import Foundation

struct FriendModel: Identifiable {
    let id = UUID()
    let name: String
    let interests: String
    let social: String
}

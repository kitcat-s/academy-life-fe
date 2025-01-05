//
//  Utils.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/22/24.
//

import SwiftUI

func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

func authErrorHandler(mode: AuthErrorMessages) -> String {
    return mode.rawValue
}

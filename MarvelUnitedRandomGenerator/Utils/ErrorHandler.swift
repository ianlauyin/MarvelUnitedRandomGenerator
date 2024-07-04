//
//  ErrorHandler.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import Foundation
import SwiftUI

class ErrorHandler : ObservableObject{
    static let shared = ErrorHandler()
    @Published private(set) var errorMessage : String? = nil
    
    func confirmError(){
        errorMessage = nil
    }
    
    func showError(_ message:String){
        errorMessage = message
    }
}

struct ErrorAlertModifier: ViewModifier {
    @StateObject var errorHandler = ErrorHandler.shared
    
    func body(content: Content) -> some View {
        content.alert(errorHandler.errorMessage ?? "Unexpected Error", isPresented: .constant(errorHandler.errorMessage != nil)) {
            Button("OK") {
                errorHandler.confirmError()
            }
        }
    }
}

extension View {
    func errorAlert() -> some View {
        self.modifier(ErrorAlertModifier())
    }
}

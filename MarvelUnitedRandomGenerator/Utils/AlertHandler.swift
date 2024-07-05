//
//  ErrorHandler.swift
//  MarvelUnitedRandomGenerator
//
//  Created by Ian Lau on 2/7/2024.
//

import Foundation
import SwiftUI

class AlertHandler : ObservableObject{
    static let shared = AlertHandler()
    @Published private(set) var message : String? = nil
    
    func confirmMessage(){
        message = nil
    }
    
    func showMessage(_ message:String){
        self.message = message
    }
}

struct CustomAlertModifier: ViewModifier {
    @StateObject var alertHandler = AlertHandler.shared
    
    func body(content: Content) -> some View {
        content.alert(alertHandler.message ?? "Unexpected Error", isPresented: .constant(alertHandler.message != nil)) {
            Button("OK") {
                alertHandler.confirmMessage()
            }
        }
    }
}

extension View {
    func customAlert() -> some View {
        self.modifier(CustomAlertModifier())
    }
}

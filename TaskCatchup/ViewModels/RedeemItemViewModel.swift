//
//  RedeemItemViewModel.swift
//  TaskCatchup
//
//  Created by Bo Wen Chan on 11/9/2026.
//

import Foundation
import Combine

/// ViewModel responsible for managing the state and business logic for the Redeem screen.
///
class RedeemItemViewModel: ObservableObject {
    @Published var profile: StudentProfile
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    
    private let purchaseUseCase = PurchaseVoucherUseCase()
    
    init() {
        // // Dummy data for testing for now
        self.profile = StudentProfile(name: "Alex", balancePoints: 40, lifetimeXP: 180, currentLevel: 2, dailyStreak: 5)
    }
    
    // Purchases a voucher
    func purchaseRestVoucher() {
        do {
            // If BP is not enough, throws error
            let updatedProfile = try purchaseUseCase.execute(voucher: .guiltFreeRest, cost: 50, profile: profile)
            self.profile = updatedProfile
            self.showSuccess = true
        } catch let error as TaskCatchupError {
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            self.errorMessage = "An unexpected error occurred."
            self.showError = true
        }
    }
}

//
//  SubscriptionManager.swift
//  GoodFood_App
//
//  Created by Guest User on 26/8/25.
//
import StoreKit
import SwiftUI

@MainActor
class SubscriptionManager: ObservableObject {
    @Published var subscriptions: [Product] = []
    @Published var purchasedSubscriptions: [Product] = []

    init() {
        Task {
            await self.fetchSubscriptions()
            await self.updatePurchasedSubscriptions()
        }
    }

    // lấy danh sách subscription từ App Store Connect
    func fetchSubscriptions() async {
        do {
            // dùng chính Product ID tạo trên App Store Connect
            let products = try await Product.products(for: ["com.GoodFood.premium.monthly"])
            self.subscriptions = products
        } catch {
            print("Lỗi fetch subscriptions: \(error)")
        }
    }

    // mua subscription
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    await self.updatePurchasedSubscriptions()
                    print("Mua thành công: \(transaction.productID)")
                }
            case .userCancelled:
                print("Người dùng huỷ")
            default:
                break
            }
        } catch {
            print("Lỗi mua: \(error)")
        }
    }

    // kiểm tra những subscription đã mua
    func updatePurchasedSubscriptions() async {
        var purchased: [Product] = []

        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if let product = try? await Product.products(for: [transaction.productID]).first {
                    purchased.append(product)
                }
            }
        }

        self.purchasedSubscriptions = purchased
    }

    // kiểm tra người dùng có subscription không
    func hasActiveSubscription() -> Bool {
        !self.purchasedSubscriptions.isEmpty
    }
}

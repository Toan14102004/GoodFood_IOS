//
//  SubscriptionView.swift
//  GoodFood_App
//
//  Created by Guest User on 26/8/25.
//

import StoreKit
import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @EnvironmentObject var languageManager: LanguageManager
    @State private var storeProducts: [Product] = []
    @State private var isLoading = true
    @Environment(\.dismiss) private var dismiss
    let subscriptionDetails: [String: (name: String, desc: String)] = [
        "com.GoodFood.premium.weekly": (
            name: "Gói Premium 1 Tuần ✨ ",
            desc: "Truy cập không giới hạn công thức, chế độ ăn, và tính năng VIP trong 7 ngày."
        ),
        "com.GoodFood.premium.monthly": (
            name: "Gói Premium 1 Tháng ✨ ",
            desc: "Truy cập không giới hạn công thức, chế độ ăn, và tính năng VIP trong 30 ngày."
        ),
        "com.GoodFood.premium.yearly": (
            name: "Gói Premium 1 Năm ✨ ",
            desc: "Tiết kiệm hơn 40% so với gói tháng. Trải nghiệm đầy đủ tính năng GoodFood suốt 12 tháng."
        ),
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text(languageManager.localizedString("Chọn gói Premium ✨ "))
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .foregroundColor(.yellow)

            ScrollView {
                if isLoading {
                    ProgressView(languageManager.localizedString("Đang tải gói…"))
                } else {
                    // Hiển thị danh sách gói
                    ForEach(storeProducts, id: \.id) { product in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(languageManager.localizedString(subscriptionDetails[product.id]?.name ?? product.displayName))
                                .font(.headline)
                            Text(languageManager.localizedString(subscriptionDetails[product.id]?.desc ?? product.description))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(languageManager.localizedString(product.displayPrice))
                                .font(.subheadline)
                                .foregroundColor(.blue)
   
                            Button(action: {
                                Task {
                                    await purchase(product)
                                }
                            }) {
                                Text(languageManager.localizedString("Đăng ký ngay"))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 144/255, green: 185/255, blue: 78/255))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(25)
                        .shadow(radius: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(red: 144/255, green: 185/255, blue: 78/255), lineWidth: 2)
                        )
                        .padding(.horizontal, 25)
                    }
                }
                
                Text(languageManager.localizedString("\"Sau khi đăng kí gói Premium, bạn có thể đăng nhập vào tài khoản của mình trên các thiết bị khác để sử dụng gói Premium.\""))
                    .font(.subheadline)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.top, 40)
                
                Text(languageManager.localizedString("\"Gói Premium sẽ được gia hạn tự động vào cuối mỗi kỳ đăng kí. Bạn có thể huỷ đăng kí bất cứ lúc nào trong phần Cài đặt tài khoản của ứng dụng.\""))
                    .font(.subheadline)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                   
                Spacer()
            }
        }
        .task {
            await fetchProducts()
        }
    }
}

extension SubscriptionView {
    // Lấy danh sách subscription từ App Store Connect
    func fetchProducts() async {
        do {
            let ids = ["com.GoodFood.premium.weekly",
                       "com.GoodFood.premium.monthly",
                       "com.GoodFood.premium.yearly"]
            let products = try await Product.products(for: ids)
            print(" Số gói lấy được: \(products.count)")
            print("Sản phẩm của shop : \(products)")
            for p in products {
                print(" \(p.displayName) - \(p.id)")
            }
            storeProducts = products.sorted { $0.displayPrice < $1.displayPrice }
            isLoading = false
        } catch {
            print("Lỗi fetch products: \(error)")
        }
    }
    
    // Hàm mua subscription
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                switch verification {
                case .unverified(_, let error):
                    print(" Giao dịch KHÔNG hợp lệ: \(error.localizedDescription)")
                case .verified(let transaction):
                    print(" Mua thành công: \(transaction.productID)")
                    await transaction.finish()
                    await subscriptionManager.updatePurchasedSubscriptions()
                    
                    await MainActor.run {
                        dismiss()
                    }
                }
                
            case .userCancelled:
                print(" Người dùng hủy")
                
            case .pending:
                print(" Giao dịch đang chờ xử lý")
                
            @unknown default:
                break
            }
        } catch {
            print("Lỗi khi mua: \(error.localizedDescription)")
        }
    }
}

////
////  BundleEx.swift
////  GoodFood_App
////
////  Created by Guest User on 22/8/25.
////
//import Foundation
//import ObjectiveC
//
//private var bundleKey: UInt8 = 0
//
//import Foundation
//
//class BundleEx: Bundle {
//    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
//        if let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle {
//            return bundle.localizedString(forKey: key, value: value, table: tableName)
//        }
//        return super.localizedString(forKey: key, value: value, table: tableName)
//    }
//}
//
//extension Bundle {
//    static func setLanguage(_ language: String) {
//        defer {
//            object_setClass(Bundle.main, BundleEx.self)
//        }
//        objc_setAssociatedObject(Bundle.main, &bundleKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//
//        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
//           let langBundle = Bundle(path: path)
//        {
//            objc_setAssociatedObject(Bundle.main, &bundleKey, langBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//}

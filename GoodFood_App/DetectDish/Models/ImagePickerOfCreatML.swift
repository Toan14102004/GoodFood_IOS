//
//  ImagePickerOfCreatML.swift
//  GoodFood_App
//
//  Created by Guest User on 7/8/25.
//
//import SwiftUI
//import UIKit
//
//struct ImagePickerOfCreatML: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//    var onImagePicked: (UIImage) -> Void
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePickerOfCreatML
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            picker.dismiss(animated: true)
//
//            if let uiImage = info[.originalImage] as? UIImage {
//                parent.image = uiImage
//                parent.onImagePicked(uiImage)
//            }
//        }
//    }
//}
//

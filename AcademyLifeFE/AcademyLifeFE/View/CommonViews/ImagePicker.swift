import SwiftUI
import PhotosUI

class ImagePickerCoordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: ImagePicker

    init(parent: ImagePicker) {
        self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        parent.images.removeAll() // 기존에 선택된 이미지들 지우기
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        if let uiImage = image as? UIImage {
                            self.parent.images.append(uiImage) // 새로운 이미지 추가하기
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage] // 이미지가 1개 이상일 경우를 대비해 Array로 구현
    var selectionLimit: Int

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = selectionLimit
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(parent: self)
    }
}

struct ImagePickerView: View {
    @State private var isPickerPresented: Bool = false
    @State private var selectedImages: [UIImage] = []

    var body: some View {
        VStack {
            // 선택된 이미지를 가로 스크롤 뷰에 보여주기
            if !selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                                .clipped()
                        }
                    }
                    .padding()
                }
            } else {
                Text("이미지를 선택하세요.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            }

            Button(action: {
                isPickerPresented.toggle()
            }) {
                Text("사진 선택")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $isPickerPresented) {
                ImagePicker(images: $selectedImages, selectionLimit: 3)
            }
        }
        .padding()
    }
}

#Preview {
    ImagePickerView()
}

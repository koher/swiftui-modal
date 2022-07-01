import SwiftUI
import SwiftUIModal
import UIKit

struct SimplePresentAndDismissView: View {
    let presentationStyle: UIModalPresentationStyle

    @State private var presentsChild: Bool = false

    var body: some View {
        ZStack {
            Color.green
            Button("Present") {
                presentsChild = true
            }
        }
        .modal(isPresented: $presentsChild, presentationStyle: presentationStyle, backgroundColor: .systemGray.withAlphaComponent(0.5)) {
            Button("Dismiss") {
                presentsChild = false
            }
            .background {
                Color.yellow
                    .frame(width: 200, height: 200)
            }
        }
    }
}

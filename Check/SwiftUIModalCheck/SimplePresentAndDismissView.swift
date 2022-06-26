import SwiftUI
import SwiftUIModal
import UIKit

struct SimplePresentAndDismissView: View {
    let presentationStyle: UIModalPresentationStyle

    @State private var presentsChild: Bool = false

    var body: some View {
        Button("Present") {
            presentsChild = true
        }
        .modal(isPresented: $presentsChild, presentationStyle: presentationStyle) {
            Color.yellow
                .ignoresSafeArea()
                .overlay {
                    Button("Dismiss") {
                        presentsChild = false
                    }
                }
        }
    }
}

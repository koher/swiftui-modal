import XCTest
import SwiftUI
import Foundation
@testable import SwiftUIModal

final class SwiftUIModalTests: XCTestCase {
    func testExample() throws {
        _ = ExampleView()
    }
}

private
struct ExampleView: View {
    @State private var presentsModalView: Bool = false

    var body: some View {
        Button("Present Modal View") {
            presentsModalView = true
        }
        .modal(
            isPresented: $presentsModalView,
            presentationStyle: .overCurrentContext,
            transitionStyle: .crossDissolve,
            backgroundColor: .black.withAlphaComponent(0.7)
        ) {
            Text("Modal View")
                .foregroundColor(.black)
                .frame(width: 200, height: 200)
                .background(Color.white)
        }
    }
}

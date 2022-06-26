import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Simple Present and Dismiss") {
                    ForEach(UIModalPresentationStyle.allCases) { presentationStyle in
                        NavigationLink {
                            SimplePresentAndDismissView(presentationStyle: presentationStyle)
                                .navigationTitle("Simple Present and Dismiss (\(presentationStyle.description))")
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            Text(presentationStyle.description)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

extension UIModalPresentationStyle: CaseIterable {
    public static var allCases: [UIModalPresentationStyle] {
        [
            .automatic,
            .currentContext,
            .custom,
            .formSheet,
            .fullScreen,
            .none,
            .overCurrentContext,
            .overFullScreen,
            .pageSheet,
            .popover,
        ]
    }
}

extension UIModalPresentationStyle: CustomStringConvertible {
    public var description: String {
        switch self {
        case .automatic: return "Automatic"
        case .currentContext: return "Current Context"
        case .custom: return "Custom"
        case .formSheet: return "Form Sheet"
        case .fullScreen: return "Full Screen"
        case .none: return "None"
        case .overCurrentContext: return "Over Current Context"
        case .overFullScreen: return "Over Full Screen"
        case .pageSheet: return "Page Sheet"
        case .popover: return "Popover"
        @unknown default: return "Unknown"
        }
    }
}

extension UIModalPresentationStyle: Identifiable {
    public var id: Int { rawValue }
}

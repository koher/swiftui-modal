import SwiftUI
import UIKit

extension View {
    public func modal<Content: View>(
        isPresented: Binding<Bool>,
        presentationStyle: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle = .coverVertical,
        backgroundColor: UIColor? = nil,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modal(
            item: Binding(
                get: { isPresented.wrappedValue ? Empty() : nil },
                set: { newValue in isPresented.wrappedValue = newValue != nil }
            ),
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            backgroundColor: backgroundColor,
            onDismiss: onDismiss,
            content: { _ in content() }
        )
    }

    public func modal<Item: Identifiable, Cover: View>(
        item: Binding<Item?>,
        presentationStyle: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle = .coverVertical,
        backgroundColor: UIColor? = nil,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Cover
    ) -> some View {
        self.modifier(ModalModifier(
            item: item,
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            backgroundColor: backgroundColor,
            onDismiss: onDismiss,
            modalContent: content
        ))
    }
}

private struct ModalModifier<Item: Identifiable, ModalContent: View>: ViewModifier {
    @Binding var item: Item?
    let presentationStyle: UIModalPresentationStyle
    let transitionStyle: UIModalTransitionStyle
    let backgroundColor: UIColor?
    let onDismiss: (() -> Void)?
    let modalContent: (Item) -> ModalContent

    func body(content: Content) -> some View {
        ZStack {
            ModalPresenterView(
                item: $item,
                presentationStyle: presentationStyle,
                transitionStyle: transitionStyle,
                backgroundColor: backgroundColor,
                onDismiss: onDismiss,
                content: modalContent
            )
                .frame(width: 0, height: 0)
            content
        }
    }
}

private struct ModalPresenterView<Item: Identifiable, Content: View>: UIViewControllerRepresentable {
    @Binding var item: Item?
    let presentationStyle: UIModalPresentationStyle
    let transitionStyle: UIModalTransitionStyle
    let backgroundColor: UIColor?
    let onDismiss: (() -> Void)?
    let content: (Item) -> Content

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ viewController: UIViewController, context: Context) {
        if item?.id == context.coordinator.lastItem?.id {
            if
                let contentViewController = viewController.presentedViewController,
                contentViewController === context.coordinator.presentedViewController
            {
                updateContentViewController(contentViewController)
            }
            return
        }
        defer { context.coordinator.lastItem = item }
        if let _ = item {
            let contentViewController = UIHostingController(rootView: Group {
                if let item = self.item {
                    content(item)
                }
            })
            updateContentViewController(contentViewController)
            contentViewController.presentationController?.delegate = context.coordinator

            context.coordinator.presentedViewController = contentViewController
            viewController.present(contentViewController, animated: true, completion: nil)
        } else {
            guard
                let contentViewController = viewController.presentedViewController,
                contentViewController === context.coordinator.presentedViewController
            else { return }
            context.coordinator.presentedViewController = nil
            viewController.dismiss(animated: true, completion: onDismiss)
        }
    }

    private func updateContentViewController(_ contentViewController: UIViewController) {
        contentViewController.modalPresentationStyle = presentationStyle
        contentViewController.modalTransitionStyle = transitionStyle
        if let backgroundColor = self.backgroundColor {
            contentViewController.view.backgroundColor = backgroundColor
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(item: $item)
    }

    final class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        @Binding var item: Item?
        var lastItem: Item?
        fileprivate var presentedViewController: UIViewController?

        init(item: Binding<Item?>) {
            self._item = item
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            item = nil
        }
    }
}

private struct Empty: Identifiable {
    var id: ID { ID() }
    struct ID: Hashable {
    }
}

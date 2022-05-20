# SwiftUIModal

_SwiftUIModal_ provides the `.modal` modifier for SwiftUI `View`s, which makes it possible to present another view with specified `presentationStyle` and `transitionStyle`.

```swift
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
```

## License

MIT

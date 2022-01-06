////
////  SwiftUIView.swift
////
////
////  Created by Márk József Alexa on 2022. 01. 06..
////
//
//import SwiftUI
//
////
////  DesignTextField.swift
////  DesignKit
////
////  Created by Szabó Zoltán on 2021. 10. 22..
////
//
//import SwiftUI
//import UIKit
//
//public enum ValidationState: Equatable {
//    case normal
//    case loading
//    case validated
//    case warning(text: String)
//    case error(text: String)
//}
//
//// swiftlint:disable all
//@available(iOS 15.0, *)
//public struct DesignTextField: View {
//    @Environment(\.isEnabled) var isEnabled
//
//    private let cornerRadius: CGFloat = 10
//    private let height: CGFloat = 48
//
//    let title: String
//    let state: ValidationState
//    let prefix: String
//    let prompt: String
//    let hint: String
//    let infoButtonText: String
//    let infoButtonTextAction: () -> Void
//    let infoButtonImageAction: (() -> Void)?
//    let secured: Bool
//    @Binding var text: String
//    @FocusState private var focused: Bool
//
//    public init(
//        title: String = "",
//        prefix: String = "",
//        text: Binding<String>,
//        prompt: String = "",
//        hint: String = "",
//        infoButtonText: String = "",
//        infoButtonTextAction: @escaping () -> Void = {},
//        infoButtonImageAction: (() -> Void)? = nil,
//        secured: Bool = false,
//        validationState: ValidationState
//    ) {
//        self._text = text
//        self.title = title
//        self.prefix = prefix
//        self.prompt = prompt
//        self.hint = hint
//        self.infoButtonText = infoButtonText
//        self.infoButtonTextAction = infoButtonTextAction
//        self.infoButtonImageAction = infoButtonImageAction
//        self.secured = secured
//        self.state = validationState
//    }
//
//    public var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            HStack {
//                if !title.isEmpty {
//                    Text(title)
//                        .foregroundColor(.defaultSecondaryText)
//                        .font(.body2)
//                        .frame(height: 20)
//                        .padding(.bottom, .xs)
//                }
//                if let infoButtonImageAction = infoButtonImageAction {
//                    Button {
//                        infoButtonImageAction()
//                    } label: {
//                        Image(.info)
//                            .padding(.bottom, .xs)
//                            .foregroundColor(.defaultTertiaryText)
//                    }
//                }
//                if !infoButtonText.isEmpty {
//                    Spacer()
//                    Button(infoButtonText) {
//                        infoButtonTextAction()
//                    }
//                    .padding(.bottom, .xs)
//                    .font(.headings6)
//                    .foregroundColor(.highlightedPrimary)
//                }
//            }
//            ZStack {
//                backgroundWithBorder
//
//                HStack(spacing: 0) {
//                    if !prefix.isEmpty {
//                        prefixView
//                    }
//                    if secured {
//                        secureField
//                    } else {
//                        editor
//                    }
//                }
//            }
//            .background(Color.defaultBackgroundAlt)
//
//            if let errorText = errorText, !errorText.isEmpty {
//                errorView(with: errorText)
//                    .padding(.top, .xs)
//            }
//            if hint.count > 0 {
//                hintView()
//                    .padding(.top, .xs)
//            }
//        }
//        .padding(.vertical, .m)
//    }
//
//    var prefixView: some View {
//        Text(prefix)
//            .font(.body1)
//            .foregroundColor(textColor)
//            .padding([.leading], .m)
//    }
//
//    var backgroundWithBorder: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: cornerRadius)
//                .foregroundColor(backgroundColor)
//                .frame(height: height)
//
//            RoundedRectangle(cornerRadius: cornerRadius)
//                .stroke(lineWidth: 2)
//                .foregroundColor(borderColor)
//                .frame(height: height)
//        }
//    }
//
//    func errorView(with text: String) -> some View {
//        Text(text)
//            .font(.body2)
//            .fixedSize(horizontal: false, vertical: true)
//            .multilineTextAlignment(.leading)
//            .foregroundColor(borderColor)
//            .frame(height: 28)
//    }
//
//    func hintView() -> some View {
//        Text(hint)
//            .font(.body2)
//            .fixedSize(horizontal: false, vertical: true)
//            .multilineTextAlignment(.leading)
//            .foregroundColor(.defaultTertiaryText)
//    }
//
//    var secureField: some View {
//        SecureEditorView(
//            text: $text,
//            prompt: prompt,
//            textColor: textColor,
//            cursorColor: cursorColor
//        )
//            .focused($focused)
//            .frame(height: 48)
//    }
//
//    var editor: some View {
//        EditorView(
//            text: $text,
//            prompt: prompt,
//            state: state,
//            textColor: textColor,
//            cursorColor: cursorColor
//        )
//            .focused($focused)
//            .frame(height: 48)
//    }
//
//    var cursorColor: Color {
//        return .highlightedPrimary
//    }
//
//    var borderColor: Color {
//        guard isEnabled else { return .clear}
//
//        switch state {
//        case .normal, .loading:
//            if focused {
//                return .highlightedPrimary
//            } else {
//                return .defaultSecondary
//            }
//        case .validated:
//            return .successPrimary
//        case .warning:
//            return Color(light: Colors.accent800, dark: Colors.yellow200)
//        case .error:
//            return .alertPrimary
//        }
//    }
//
//    var backgroundColor: Color {
//        if isEnabled {
//            return .clear
//        } else {
//            return Color(light: Colors.grey100, dark: Colors.grey900)
//        }
//    }
//
//    var textColor: Color {
//        if isEnabled {
//            return .defaultPrimaryText
//        } else {
//            return Colors.grey500
//        }
//    }
//
//    var errorText: String? {
//        switch state {
//        case .normal, .validated, .loading:
//            return nil
//        case .error(let text):
//            return text
//        case .warning(let text):
//            return text
//        }
//    }
//}
//
//private struct EditorView: View {
//    @Environment(\.isEnabled) var isEnabled
//
//    @Binding var text: String
//    let prompt: String
//    let state: ValidationState
//    let textColor: Color
//    let cursorColor: Color
//
//    var body: some View {
//        HStack {
//            TextField(
//                prompt,
//                text: $text
//            )
//                .font(.body1)
//                .accentColor(cursorColor)
//                .foregroundColor(textColor)
//                .padding(.xs)
//
//            switch state {
//            case .validated:
//                Image(.checkmark)
//                    .resizable()
//                    .foregroundColor(.successPrimary)
//                    .frame(width: 24, height: 24)
//                    .padding()
//            case .loading:
//                ProgressView()
//                    .padding()
//            default:
//                if !text.isEmpty && isEnabled {
//                    Button(
//                        action: { text.removeAll() },
//                        label: {
//                            Image(.close4)
//                                .resizable()
//                                .foregroundColor(
//                                    Color(light: Colors.grey700, dark: Colors.grey300)
//                                )
//                                .frame(width: 24, height: 24)
//                                .padding()
//                        })
//                } else {
//                    EmptyView()
//                }
//            }
//        }
//    }
//}
//
//private struct SecureEditorView: View {
//    @Environment(\.isEnabled) var isEnabled
//
//    @Binding var text: String
//    @State var isRevealed: Bool = false
//    let prompt: String
//    let textColor: Color
//    let cursorColor: Color
//
//    var body: some View {
//        HStack {
//            CustomSecureTextField(
//                text: $text,
//                prompt: prompt,
//                isRevealed: isRevealed,
//                textColor: textColor,
//                font: .body1
//            )
//                .foregroundColor(textColor)
//                .accentColor(cursorColor)
//                .padding()
//
//            if !text.isEmpty && isEnabled {
//                Button(
//                    action: {
//                        isRevealed = !isRevealed
//                    },
//                    label: {
//                        Image(isRevealed ? "view_on" : "view_off")
//                            .resizable()
//                            .frame(width: 24, height: 24)
//                            .foregroundColor(
//                                Color(light: Colors.grey700, dark: Colors.grey300)
//                            )
//                            .padding()
//                    })
//            }
//        }
//    }
//}
//
//struct CustomSecureTextField: UIViewRepresentable {
//
//    class Coordinator: NSObject, UITextFieldDelegate {
//        @Binding var text: String
//
//        init(text: Binding<String>) {
//            _text = text
//        }
//
//        func textFieldDidChangeSelection(_ textField: UITextField) {
//            text = textField.text ?? ""
//        }
//    }
//
//    @Binding var text: String
//    let prompt: String
//    let isRevealed: Bool
//    let textColor: Color
//    let font: UIFont
//
//    func makeUIView(context: UIViewRepresentableContext<CustomSecureTextField>) -> UITextField {
//        let textField = UITextField(frame: .zero)
//        textField.isSecureTextEntry = !isRevealed
//        textField.delegate = context.coordinator
//        textField.autocorrectionType = .no
//        textField.textContentType = .password
//        textField.font = font
//        textField.placeholder = prompt
//        textField.textColor = UIColor(textColor)
//        return textField
//    }
//
//    func makeCoordinator() -> CustomSecureTextField.Coordinator {
//        Coordinator(text: $text)
//    }
//
//    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomSecureTextField>) {
//        uiView.isSecureTextEntry = !isRevealed
//        uiView.text = text
//        uiView.placeholder = prompt
//    }
//}
//
//@available(iOS 15.0, *)
//struct DesignTextField_Previews: PreviewProvider {
//
//    static var previews: some View {
//        VStack {
//            DesignTextField(
//                title: "Default",
//                prefix: "+36",
//                text: .constant("20 3 203 206"),
//                prompt: "prompt",
//                hint: "Kérem adja meg a telefonszámát!",
//                validationState: .normal
//            )
//                .padding()
//
//            DesignTextField(
//                title: "Default",
//                prefix: "+36",
//                text: .constant(""),
//                prompt: "prompt",
//                infoButtonText: "Hol találom?",
//                infoButtonTextAction: {},
//                infoButtonImageAction: {},
//                validationState: .validated
//            )
//                .padding()
//
//            DesignTextField(
//                title: "Default",
//                text: .constant("text"),
//                prompt: "prompt",
//                validationState: .loading
//            )
//                .padding()
//
//            DesignTextField(
//                title: "Secured",
//                text: .constant(""),
//                prompt: "secured",
//                secured: true,
//                validationState: .normal
//            )
//                .padding()
//
//            DesignTextField(
//                title: "Disabled",
//                text: .constant("Disabled"),
//                validationState: .normal
//            )
//                .padding()
//                .disabled(true)
//                .preferredColorScheme(.light)
//        }
//    }
//}

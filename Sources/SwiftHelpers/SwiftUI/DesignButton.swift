//
//  StyledButton.swift
//  DesignKit
//
//  Created by Alexa Márk on 2021. 10. 20..
//

import SwiftUI

@available(iOS 15.0, *)
public struct DesignButton: View {
    public struct DefaultDesignButtonColor: AppButtonColors {
        public var buttonPrimaryBgrNormal: Color = Color(.systemBlue)
        public var buttonPrimaryBgrPressed: Color = Color(.systemBlue.darker())
        public var buttonPrimaryBgrDisabled: Color = Color(.systemGray2)
        public var buttonSecondaryBgrNormal: Color = Color(.systemBlue.lighter())
        public var buttonSecondaryBgrPressed: Color = Color(.systemBlue)
        public var buttonSecondaryBgrDisabled: Color = Color(.systemGray2)
        public var buttonTertiaryBgrNormal: Color = .gray
        public var buttonTertiaryBgrPressed: Color = .gray
        public var buttonTertiaryBgrDisabled: Color = .gray
        public var buttonTextPrimaryNormal: Color = Color(.white)
        public var buttonTextPrimaryDisabled: Color = Color(.secondaryLabel)
        public var buttonTextSecondaryNormal: Color = Color(.white)
        public var buttonTextSecondaryDisabled: Color = Color(.secondaryLabel)
        public var buttonTextTertiaryNormal: Color = Color(.systemBlue)
        public var buttonTextTertiaryDisabled: Color = Color(.secondaryLabel)

        public init() {

        }
    }

    public enum Width {
        case fluid, fullSize
    }

    public enum Size {
        case small, medium, large, giant

        public var diameter: CGFloat {
            switch self {
            case .small:
                return 28
            case .medium:
                return 36
            case .large:
                return 48
            case .giant:
                return 60
            }
        }
    }

    public enum Style {
        case primary(_ colors: AppButtonColors = DefaultDesignButtonColor())
        case secondary(_ colors: AppButtonColors = DefaultDesignButtonColor())
        case tertiary(_ colors: AppButtonColors = DefaultDesignButtonColor())
    }

    let style: Style
    let width: Width
    let size: Size
    let title: String?
    let image: Image?
    let bgrColor: Color?
    let spacer: Bool
    let isLoading: Bool
    let action: () -> Void

    public init(
        style: Style = .primary(DefaultDesignButtonColor()),
        width: Width = .fullSize,
        size: Size = .large,
        title: String? = nil,
        image: Image? = nil,
        bgrColor: Color? = nil,
        spacer: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void) {
            self.style = style
            self.width = width
            self.size = size
            self.title = title
            self.image = image
            self.bgrColor = bgrColor
            self.spacer = spacer
            self.isLoading = isLoading
            self.action = action
        }

    public var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                ZStack {
                    HStack {
                        if width == .fullSize {
                            Spacer()
                        }
                        if let image = self.image {
                            image
                                .resizable()
                                .frame(width: imageSize, height: imageSize)
                        }
                        if spacer { Spacer() }
                        if let title = title, hasTitle {
                            Text(title)
                                .multilineTextAlignment(.center)
                        }
                        if width == .fullSize {
                            Spacer()
                        }
                        if spacer { Spacer() }
                    }
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .tint(.black)
                        }
                    }
                }
                .padding(.horizontal, padding)
                .frame(minWidth: height)
                .frame(height: height)
            })
            .buttonStyle(ThemedButtonStyle(style: style, bgrColor: bgrColor))
            .font(font)
    }

    var hasTitle: Bool {
        if let title = title {
            return !title.isEmpty
        }
        return false
    }

    var height: CGFloat {
        size.diameter
    }

    var padding: CGFloat {
        switch size {
        case .small:
            return hasTitle ? .s : .xxs
        case .medium:
            return hasTitle ? .m : .xs
        case .large:
            return hasTitle ? .l : .s
        case .giant:
            return hasTitle ? .xl : .m
        }
    }

    var imageSize: CGFloat {
        switch size {
        case .small:
            return .s
        case .medium:
            return .m
        case .large:
            return .xxl
        case .giant:
            return .xxl
        }
    }

    var font: Font {
        switch size {
        case .small:
            return .subBold
        case .medium:
            return .textBold
        case .large:
            return .titleBold
        case .giant:
            return .header2
        }
    }
}

@available(iOS 15.0, *)
private extension DesignButton.Style {
    func backgroundColor(isEnabled: Bool, isPressed: Bool) -> Color {
        switch self {
        case .primary(let color):
            if !isEnabled {
                return color.buttonPrimaryBgrDisabled
            } else if isPressed {
                return color.buttonPrimaryBgrPressed
            } else {
                return color.buttonPrimaryBgrNormal
            }
        case .secondary(let color):
            if !isEnabled {
                return color.buttonSecondaryBgrDisabled
            } else if isPressed {
                return color.buttonSecondaryBgrPressed
            } else {
                return color.buttonSecondaryBgrNormal
            }
        case .tertiary(_):
            return .clear
        }
    }

    func textColor(isEnabled: Bool, isPressed: Bool) -> Color {
        switch self {
        case .primary(let color):
            if !isEnabled {
                return color.buttonTextPrimaryDisabled
            } else {
                return color.buttonTextPrimaryNormal
            }
        case .secondary(let color):
            if !isEnabled {
                return color.buttonTextSecondaryDisabled
            } else {
                return color.buttonTextSecondaryNormal
            }
        case .tertiary(let color):
            if !isEnabled {
                return color.buttonTextTertiaryDisabled
            } else {
                return color.buttonTextTertiaryNormal
            }
        }
    }
}

@available(iOS 15.0, *)
private struct ThemedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    private let style: DesignButton.Style
    private let bgrColor: Color?

    init(style: DesignButton.Style, bgrColor: Color? = nil) {
        self.style = style
        self.bgrColor = bgrColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Group {
                    if let bgrColor = bgrColor {
                        Capsule().fill(
                            Color(configuration.isPressed ? UIColor(bgrColor).darker() : UIColor(bgrColor))
                        )
                    } else {
                        Capsule().fill(
                            style.backgroundColor(
                                isEnabled: isEnabled,
                                isPressed: configuration.isPressed)
                        )
                    }
                }
            )
            .foregroundColor(
                style.textColor(
                    isEnabled: isEnabled,
                    isPressed: configuration.isPressed
                )
            )
    }
}

@available(iOS 15.0, *)
struct DesignButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DesignButton(
                style: .primary(DesignButton.DefaultDesignButtonColor()),
                width: .fluid,
                size: .small,
                image: Image(systemName: "xmark"),
                action: {}
            )
                .disabled(true)

            DesignButton(
                style: .primary(DesignButton.DefaultDesignButtonColor()),
                width: .fluid,
                size: .medium,
                title: "Belépés",
                action: {}
            )
                .disabled(false)

            DesignButton(
                style: .primary(DesignButton.DefaultDesignButtonColor()),
                width: .fullSize,
                size: .large,
                title: "Checkout",
                image: Image(systemName: "xmark"),
                action: {}
            )
                .disabled(false)

            DesignButton(
                style: .primary(DesignButton.DefaultDesignButtonColor()),
                width: .fluid,
                size: .large,
                title: "Checkout",
                image: Image(systemName: "xmark"),
                spacer: true,
                action: {}
            )
                .disabled(false)

            DesignButton(
                style: .secondary(DesignButton.DefaultDesignButtonColor()),
                width: .fluid,
                size: .medium,
                title: "Belépés",
                image: Image(systemName: "xmark"),
                bgrColor: .red,
                action: {}
            )
                .disabled(false)

            DesignButton(
                style: .tertiary(DesignButton.DefaultDesignButtonColor()),
                width: .fluid,
                size: .medium,
                title: "Belépés",
                action: {}
            )
                .disabled(false)
        }
        .padding()
        .preferredColorScheme(.light)
    }
}

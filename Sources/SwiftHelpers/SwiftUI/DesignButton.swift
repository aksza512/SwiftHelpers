//
//  StyledButton.swift
//  DesignKit
//
//  Created by Alexa Márk on 2021. 12. 05..
//

import SwiftUI

public protocol DesignButtonColorProtocol {
    func backgroundColor(isEnabled: Bool, isPressed: Bool) -> Color
    func textColor(isEnabled: Bool, isPressed: Bool) -> Color
}

public enum DesignButtonDefaultColor: DesignButtonColorProtocol {
    case normal
    
    public func backgroundColor(isEnabled: Bool, isPressed: Bool) -> Color {
        if !isEnabled {
            return .yellow
        } else if isPressed {
            return .orange
        } else {
            return .black
        }
    }

    public func textColor(isEnabled: Bool, isPressed: Bool) -> Color {
        if !isEnabled {
            return .gray
        } else {
            return .red
        }
    }
}

public struct DesignButton: View {

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

    let width: Width
    let size: Size
    let title: String?
    let image: Image?
    let colors: DesignButtonColorProtocol
    let action: () -> Void

    public init(
        width: Width = .fullSize,
        size: Size = .large,
        title: String? = nil,
        image: Image? = nil,
        colors: DesignButtonColorProtocol = DesignButtonDefaultColor.normal,
        action: @escaping () -> Void) {
        self.colors = colors
        self.width = width
        self.size = size
        self.title = title
        self.image = image
        self.action = action
    }

    public var body: some View {
        Button(action: action, label: {
            HStack {
                if width == .fullSize {
                    Spacer()
                }
                if let image = self.image {
                    image
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                }
                if let title = title, hasTitle {
                    Text(title)
                }
                if width == .fullSize {
                    Spacer()
                }
            }
            .padding(.horizontal, padding)
            .frame(minWidth: height)
            .frame(height: height)
        })
            .buttonStyle(ThemedButtonStyle(colors: colors))
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
            return .l
        case .medium:
            return .l
        case .large:
            return .xl
        case .giant:
            return .xxl
        }
    }

    var font: Font {
        switch size {
        case .small:
            return .headings7
        case .medium:
            return .headings6
        case .large:
            return .headings5
        case .giant:
            return .headings4
        }
    }
}

private struct ThemedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    private let colors: DesignButtonColorProtocol
    
    init(colors: DesignButtonColorProtocol) {
        self.colors = colors
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Capsule().fill(
                    colors.backgroundColor(
                        isEnabled: isEnabled,
                        isPressed: configuration.isPressed)
                )
            )
            .foregroundColor(
                colors.textColor(
                    isEnabled: isEnabled,
                    isPressed: configuration.isPressed
                )
            )
    }
}

struct DesignButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DesignButton(
                width: .fluid,
                size: .small,
                image: Image(systemName: "gift"),
                action: {}
            )

            DesignButton(
                width: .fluid,
                size: .medium,
                image: Image(systemName: "gift"),
                action: {}
            )
            .disabled(false)

            DesignButton(
                width: .fullSize,
                size: .large,
                title: "Checkout",
                image: Image(systemName: "gift"),
                action: {}
            )
            .disabled(false)

            DesignButton(
                width: .fluid,
                size: .medium,
                title: "Belépés",
                image: Image(systemName: "gift"),
                action: {}
            )
            .disabled(false)

            DesignButton(
                width: .fluid,
                size: .medium,
                title: "Belépés",
                action: {}
            )
            .disabled(false)
            DesignButton(
                width: .fluid,
                size: .medium,
                title: "Belépés",
                action: {}
            )
            .disabled(true)

//            DesignButton(
//                width: .fluid,
//                size: .medium,
//                title: "Belépés",
//                colors: ButtonColor.normal,
//                action: {}
//            )
        }
        .preferredColorScheme(.light)
    }
}

//enum ButtonColor: DesignButtonColorProtocol {
//    case normal
//
//    func backgroundColor(isEnabled: Bool, isPressed: Bool) -> Color {
//        .blue
//    }
//
//    func textColor(isEnabled: Bool, isPressed: Bool) -> Color {
//        .white
//    }
//}

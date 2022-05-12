////
////  SwiftUIView.swift
////
////
////  Created by Márk József Alexa on 2022. 01. 24..
////
//
//import SwiftUI
//
//@available(iOS 15.0, *)
//struct DesignTabView: View {
//    @State private var selectedTab: Int = 0
//    private let tabs: [String] = ["Első hét", "Második hét", "Hello te gyökér"]
//
//    var body: some View {
//        VStack {
//            TabHeaderView(selectedTab: $selectedTab, tabs: tabs)
//            TabPagerView(selectedTab: $selectedTab, tabs: tabs)
//        }
//    }
//}
//
//@available(iOS 15.0, *)
//struct TabHeaderView: View {
//
//    @Binding var selectedTab: Int
//    let tabs: [String]
//
//    @Namespace private var namespace
//
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            buttons
//            underline
//        }
//        .padding(.horizontal)
//    }
//
//    var buttons: some View {
//        HStack {
//            ForEach(tabs, id: \.self) { tab in
//                Button {
//                    selectedTab = tabs.firstIndex(of: tab) ?? 0
//                } label: {
//                    Text(tab)
//                        .foregroundColor(tabs.firstIndex(of: tab) == selectedTab ? .black : .gray)
//                        .font(.system(size: 16, weight: .bold, design: .rounded))
//                        .padding(.vertical, 8)
//                        .matchedGeometryEffect(id: tab, in: namespace, properties: .frame, isSource: true)
//                }
//            }
//
//            Spacer()
//        }
//    }
//
//    var underline: some View {
//        RoundedRectangle(cornerRadius: 8, style: .continuous)
//            .fill(.teal)
//            .frame(height: 3)
//            .matchedGeometryEffect(id: tabs[selectedTab], in: namespace, properties: .frame, isSource: false)
//            .animation(.easeOut(duration: 0.2), value: selectedTab)
//    }
//}
//
//@available(iOS 15.0, *)
//struct TabPagerView: View {
//
//    @Binding var selectedTab: Int
//    let tabs: [String]
//
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            ForEach(tabs, id: \.self) { tab in
//                Text(tab)
//                    .font(.system(size: 32, weight: .bold, design: .rounded))
//                    .tag(tabs.firstIndex(of: tab) ?? 0)
//            }
//        }
//        .tabViewStyle(.page(indexDisplayMode: .never))
//        .animation(.easeOut, value: selectedTab)
//    }
//}
//
//@available(iOS 15.0, *)
//struct DesignTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        DesignTabView()
//    }
//}



//
//  SwiftUIView.swift
//
//
//  Created by Márk József Alexa on 2022. 01. 24..
//

import SwiftUI

public struct TabHeaderViewItem: Identifiable, Hashable {
    public static func == (lhs: TabHeaderViewItem, rhs: TabHeaderViewItem) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public let id = UUID().uuidString
    public let title: String
    public let image: Image?
    
    public init(title: String, image: Image?) {
        self.title = title
        self.image = image
    }
}

@available(iOS 15.0, *)
public struct DesignTabView: View {
    @State private var selectedTab: Int = 0
    private let tabs: [TabHeaderViewItem] = [
        .init(title: "Hirdetések", image: Image(systemName: "star.fill")),
        .init(title: "Keresések", image: Image(systemName: "magnifyingglass"))
    ]

    public var body: some View {
        VStack {
            TabHeaderView(selectedTab: $selectedTab, tabs: tabs, fullHeightHeader: true)
            TabHeaderView(selectedTab: $selectedTab, tabs: tabs, fullHeightHeader: false)
            TabPagerView(selectedTab: $selectedTab, tabs: tabs, views: [
                AnyView(Text("asd")),
                AnyView(Text("as1")),
                AnyView(Text("as2"))
            ])
        }
    }
}

@available(iOS 15.0, *)
public struct TabHeaderView: View {

    @Binding var selectedTab: Int
    let tabs: [TabHeaderViewItem]
    let titleColor: Color
    let titleColorSelected: Color
    let underlineColor: Color
    let fullHeightHeader: Bool
    let bgrColor: Color

    @Namespace private var namespace

    public init(
        selectedTab: Binding<Int>,
        tabs: [TabHeaderViewItem],
        titleColor: Color = UIColor.label.color,
        titleColorSelected: Color = UIColor.systemGray.color,
        underlineColor: Color = UIColor.secondaryLabel.color,
        fullHeightHeader: Bool = false,
        bgrColor: Color = .clear
    ) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.titleColor = titleColor
        self.titleColorSelected = titleColorSelected
        self.underlineColor = underlineColor
        self.fullHeightHeader = fullHeightHeader
        self.bgrColor = bgrColor
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            buttons
                .background(bgrColor)
            underline
        }
    }

    var buttons: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                Button {
                    selectedTab = tabs.firstIndex(of: tab) ?? 0
                } label: {
                    HStack {
                        if let image = tab.image {
                            image
                                .foregroundColor(tabs.firstIndex(of: tab) == selectedTab ? titleColorSelected : titleColor)
                                .font(.system(size: 14, weight: tabs.firstIndex(of: tab) == selectedTab ? .bold : .regular, design: .rounded))
                        }
                        Text(tab.title)
                            .foregroundColor(tabs.firstIndex(of: tab) == selectedTab ? titleColorSelected : titleColor)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .padding(.vertical, 14)
                    }
                }
                .if(fullHeightHeader, transform: { view in
                    view
                        .frame(maxWidth: .infinity)
                })
                .matchedGeometryEffect(id: tab, in: namespace, properties: .frame, isSource: true)
            }
            if !fullHeightHeader {
                Spacer()
            }
        }
    }

    var underline: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(underlineColor)
            .frame(height: 2)
            .matchedGeometryEffect(id: tabs.safeAt(selectedTab) ?? .init(title: "", image: nil), in: namespace, properties: .frame, isSource: false)
            .animation(.easeOut(duration: 0.2), value: selectedTab)
    }
}

@available(iOS 15.0, *)
public struct TabPagerView: View {

    @Binding var selectedTab: Int
    let tabs: [TabHeaderViewItem]
    let views: [AnyView]
    let disableSwipe: Bool

    public init(selectedTab: Binding<Int>, tabs: [TabHeaderViewItem], views: [AnyView], disableSwipe: Bool = false) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.views = views
        self.disableSwipe = disableSwipe
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(0 ..< views.count, id: \.self) { index in
                views[index]
                    .tag(index)
                    .gesture(disableSwipe ? DragGesture() : nil)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeOut, value: selectedTab)
    }
}

@available(iOS 15.0, *)
struct DesignTabView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            DesignTabView()
        }
        .preferredColorScheme(.light)
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

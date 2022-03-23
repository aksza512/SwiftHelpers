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

@available(iOS 15.0, *)
public struct DesignTabView: View {
    @State private var selectedTab: Int = 0
    private let tabs: [String] = ["Első hét", "Második hét", "Hello te gyökér"]

    public var body: some View {
        VStack {
            TabHeaderView(selectedTab: $selectedTab, tabs: tabs)
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
    let tabs: [String]

    @Namespace private var namespace

    public init(selectedTab: Binding<Int>, tabs: [String]) {
        self._selectedTab = selectedTab
        self.tabs = tabs
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            buttons
            underline
        }
        .padding(.horizontal)
    }

    var buttons: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                Button {
                    selectedTab = tabs.firstIndex(of: tab) ?? 0
                } label: {
                    Text(tab)
                        .foregroundColor(tabs.firstIndex(of: tab) == selectedTab ? UIColor.label.color : UIColor.systemGray.color)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .padding(.vertical, 8)
                        .matchedGeometryEffect(id: tab, in: namespace, properties: .frame, isSource: true)
                }
            }

            Spacer()
        }
    }

    var underline: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(.teal)
            .frame(height: 3)
            .matchedGeometryEffect(id: tabs.safeAt(selectedTab) ?? "", in: namespace, properties: .frame, isSource: false)
            .animation(.easeOut(duration: 0.2), value: selectedTab)
    }
}

@available(iOS 15.0, *)
public struct TabPagerView: View {

    @Binding var selectedTab: Int
    let tabs: [String]
    let views: [AnyView]

    public init(selectedTab: Binding<Int>, tabs: [String], views: [AnyView]) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.views = views
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(0 ..< views.count, id: \.self) { index in
                views[index]
                    .tag(index)
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
            Color.gray
                .ignoresSafeArea()
            DesignTabView()
        }
        .preferredColorScheme(.light)
    }
}

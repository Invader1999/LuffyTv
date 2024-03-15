//
//  TabBarItem.swift
//  LuffyTV
//
//  Created by Hemanth Reddy Kareddy on 14/03/24.
//

import SwiftUI

struct TabBarItemView: View {
    @State var imageName:String
    @State var title:String
    var body: some View {
        VStack{
            Image(systemName: imageName)
                .environment(\.symbolVariants, .none)
            Text(title)
        }
    }
}

#Preview {
    TabBarItemView(imageName:"house", title:"Home")
}

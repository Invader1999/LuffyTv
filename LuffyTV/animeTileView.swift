//
//  animeTileView.swift
//  LuffyTV
//
//  Created by Hemanth Reddy Kareddy on 14/03/24.
//

import SwiftUI
import NukeUI

struct animeTileView: View {
    @State var imageUrl:String
    @State var title:String
    var body: some View {
            VStack(spacing:0){
            LazyImage(source: imageUrl) { state in
                if let image = state.image{
                    image
                        .resizingMode(.aspectFit)
                        //.aspectRatio(contentMode: .fit)
                        .frame(width:180,height: 250)
                        .padding(.horizontal,0)
                        
                        
                }
                else{
                    Rectangle()
                }
            }
                VStack{
                    Text(title)
                        .font(.subheadline)
                        .lineLimit(1)
                        .padding(.vertical,8)
                        .multilineTextAlignment(.leading)
                        .padding(.leading,8)
                        

                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity,alignment:.leading)
                .frame(width:177)
                .background(.black)
           
        }

    }
}

#Preview {
    animeTileView(imageUrl: "https://cdn.myanimelist.net/images/anime/1056/109094.jpg", title: "The Apothecary Dairaies")
}

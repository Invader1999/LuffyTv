//
//  HomeView.swift
//  LuffyTV
//
//  Created by Hemanth Reddy Kareddy on 14/03/24.
//

import SwiftUI
import NukeUI
import Shimmer


struct HomeView: View {
    @State var animeDetailsViewModel = AnimeDetailsViewModel()
    @State var topTvAnimeViewModel = TopAiringAnimeViewModel()
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(edges: [.top,.leading,.trailing])
            
            ZStack {
                LazyImage(source: animeDetailsViewModel.animeDetailDataArray.first?.mainPicture?.large) { state in
                    if let image = state.image {
                        image
                            .resizingMode(.aspectFill)
                            .overlay(content: {
                                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.7), .clear, .black]), startPoint: .top, endPoint: .bottom)
                            })
                            .frame(height:500)
                            .frame(maxHeight:.infinity,alignment: .top)
                            .ignoresSafeArea(edges: [.top])
                    }
                }
                
            }
            ScrollView{
                VStack{
                    VStack {
                        Text(animeDetailsViewModel.animeDetailDataArray.first?.title ?? "")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
                            
                        Text(animeDetailsViewModel.animeDetailDataArray.first?.synopsis ?? "")
                        .lineLimit(3)
                        .frame(width: 300)
                        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
                        
                    }
                    .padding(.leading)
    
                    VStack{
                        Text("Top Airing Anime")
                            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
                        
                        ScrollView(.horizontal) {
                            HStack{
                                ForEach(topTvAnimeViewModel.topAirAnimeDataArray,id:\.id) { item in
                                   
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
                    .padding(.leading)

                }
                
                .foregroundStyle(.white)
               
                .padding(.top,280)
            }
            
        }
        .task {
            Task{
                try await animeDetailsViewModel.getAnimeDetailsData(id:"21")
            }
        }
        .toolbar{
            ToolbarItem {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white)
            }
        }
        
    }
}

#Preview {
    HomeView()
}



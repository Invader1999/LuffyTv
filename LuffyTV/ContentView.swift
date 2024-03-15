//
//  ContentView.swift
//  LuffyTV
//
//  Created by Hemanth Reddy Kareddy on 11/03/24.
//

import SwiftUI

struct ContentView: View {
    @State var topAiringListViewModel = TopAiringAnimeViewModel()
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        UITabBar.appearance().backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundColor = UIColor.clear
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
       }
    
    var body: some View {
        NavigationStack{
    
                TabView {
                    HomeView()
                        .tabItem {
                           TabBarItemView(imageName: "house", title: "Home")
                        }
                    
                    MyListView()
                        .tabItem {
                           TabBarItemView(imageName: "bookmark", title: "MyList")
                        }
                    
                    BrowseView()
                        .tabItem {
                           TabBarItemView(imageName: "square.grid.2x2", title: "Browse")
                        }
                   
                    AccountView()
                        .tabItem {
                           TabBarItemView(imageName: "circle.fill", title: "Home")
                        }
                }
                
                .tint(Color.orange)
            
//                .onAppear {
//                        let appearance = UITabBarAppearance()
//                    appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//                    appearance.backgroundColor = UIColor(Color.black.opacity(0.7))
//                        // Use this appearance when scrolling behind the TabView:
//                        UITabBar.appearance().standardAppearance = appearance
//                        // Use this appearance when scrolled all the way up:
//                        UITabBar.appearance().scrollEdgeAppearance = appearance
//                }
        }
    }
}

#Preview {
    ContentView()
}

//            ScrollView{
//                VStack {
//                    ForEach(topAiringListViewModel.topAirAnimeDataArray,id: \.id){ item in
//                        ForEach(item.data,id: \.node.id){mainData in
//                            Text(mainData.node.title)
//                            AsyncImage(url: URL(string: mainData.node.mainPicture.medium))
//                                .overlay {
//                                    Text("\(mainData.ranking.rank)")
//                                        .foregroundStyle(.white)
//                                        .bold()
//                                        .background {
//                                            Circle()
//                                                .foregroundStyle(.red)
//                                                .frame(width: 30, height: 30)
//                                        }
//                                        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment:.topTrailing)
//
//                                }
//                        }
//                    }
//                }
//            }

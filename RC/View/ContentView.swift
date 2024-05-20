//
//  ContentView.swift
//  RC
//
//  Created by 酒匂竜也 on 2024/03/07.
//

import SwiftUI
import RealmSwift
import Alamofire

struct ContentView: View {
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia", size: 26)!]
    }
    // タブの選択項目を保持する
    @State var SelectTab = 1
    var body: some View {
        TabView(selection: $SelectTab) {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    // VStackで作成したViewを構築
                    VStack {
                        RcHistoryController()
                    }
                }
                // タイトルと左右のアイコンを指定
                    .navigationBarTitle(Text("購入商品一覧"), displayMode: .inline)
                    .navigationBarItems(
                        trailing: HStack{
                            IconView(systemName: "magnifyingglass")
                            
                                .padding(.leading, 10)
                        }
                            .padding(.bottom, 10)
                    )
            }
            .tabItem {
                IconView(systemName: "house")
            }
            .tag(1)
            RcPostController()
            // 押された時に呼ばれる　今はアイコンが呼ばれる
           // IconView(systemName: "plus.app")
            
            // 下のアイコン画像
                .tabItem {
                    RcPostController()
                    IconView(systemName: "plus.app")
                }
            IconView(systemName: "camera")
                .tabItem {
                    IconView(systemName: "camera")
                }
        }
        
        // 選択されているアイコンの色を黒に変更
        .accentColor(.black)
    }
}

// Iconの形式をそろえる
struct IconView: View {
    var systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .font(.title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

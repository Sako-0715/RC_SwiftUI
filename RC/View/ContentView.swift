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
    // 投稿した履歴が入る配列
    @State private var historyDataArray: [HistoryData] = []
    // API通信するmodel
    private let baseRequestAPIModel = BaseRequestAPIModel()
    
    var body: some View {
        List {
            ForEach(historyDataArray, id: \.self) { historyData in
                HistoryRowView(historyData: historyData)
            }
            .onAppear {
                refreshData()
            }
        }
        .pullToRefresh(isShowing: $isRefreshing) {
            refreshData()
        }
    }
    
    @State private var isRefreshing = false
    
    private func refreshData() {
        let url = "http://localhost:8888/KeepFood/iOS/Controller/ShopingHistoryController.php"
        AF.request(url).responseData { response in
            switch response.result {
            case.success(let data):
                do {
                    let decoder = JSONDecoder()
                    self.historyDataArray = try decoder.decode([HistoryData].self, from: data)
                } catch {
                    print("JSONデコードエラー: \(error)")
                }
                self.isRefreshing = false
            case.failure(let error):
                print("Error: \(error)")
                self.isRefreshing = false
            }
        }
    }
}

struct HistoryRowView: View {
    let historyData: HistoryData
    @State private var image: UIImage? = nil
    
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            VStack(alignment: .leading) {
                Text(historyData.JANL)
                Text(historyData.PRODACTNAME)
                Text("\(historyData.PRICE)")
            }
        }
        .onAppear {
            loadImage()
        }
        .frame(height: 120)
    }
    
    private func loadImage() {
        let realm = try! Realm()
        let id = historyData.ID
        let realmImage = realm.objects(ImageRealm.self).filter("ID == %@", id)
        if let historyImage = realmImage.first, let imageData = historyImage.imageData {
            self.image = UIImage(data: imageData)
        }
    }
}

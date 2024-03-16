//
//  RcHistoryView.swift
//  RC
//
//  Created by 酒匂竜也 on 2024/03/15.
//

import SwiftUI
import RealmSwift
import Alamofire

struct RcHistoryView: View {
    // 投稿した履歴が入る配列
    @State private var historyDataArray: [HistoryData] = []
    // API通信するmodel
    private let baseRequestAPIModel = BaseRequestAPIModel()
    // ロード中の状態を管理
    @State private var isLoading = false
    // 投稿画像が入る変数
    @State private var image: UIImage? = nil
    
    var body: some View {
        VStack() {
            if isLoading {
                ProgressView()
            } else {
                ForEach(historyDataArray, id: \.self) { historyData in
                    VStack(spacing: 0) {
                        Divider()
                        if let image = self.image {
                            // 投稿画像がある場合はここの条件式に入る
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
                                .clipShape(Rectangle())
                        } else {
                            // 投稿画像がない場合はここの条件式に入る デフォルト画像を表示する
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
                                .clipShape(Rectangle())
                        }
                        Divider()
                        Group {
                            Text( "ジャンル:  ")
                                .font(.system(size: 16, weight: .bold))
                                +
                            Text(historyData.JANL)
                                .font(.system(size: 20, weight: .bold))
                            Text( "商品名:  ")
                                .font(.system(size: 16, weight: .bold))
                            +
                            Text(historyData.PRODACTNAME)
                                .font(.system(size: FontSize(productName: historyData.PRODACTNAME), weight: .bold))
                            Text( "個数:  ")
                                .font(.system(size: 16, weight: .bold))
                            +
                            Text("\(historyData.PRICE)")
                                .font(.system(size: 20, weight: .bold))
                            Text( "投稿日時:  ")
                                .font(.system(size: 16, weight: .bold))
                            +
                            Text(FormatDate(historyData.DATE))
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(3)
                    }
                    
                }
            }
            
        }
        .onAppear {
            Api()
            if let histroyimage = historyDataArray.first {
                loadImage(for: histroyimage)
            }
        }
    }
    /*
     APIファイルにアクセスするためのメソッド
     */
    private func Api() {
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
                
            case.failure(let error):
                print("Error: \(error)")
            }
        }
    }
    /*
     商品名の文字数が多い場合はフォントサイズを調整するためのメソッド
     */
    private func FontSize(productName: String) -> CGFloat {
        let maxLength = 20 // フォントサイズを最大にする文字数
        let minLength = 10 // フォントサイズを最小にする文字数
        let scaleFactor: CGFloat = 0.5 // 文字数1文字に対するフォントサイズの減少率
        let productNameLength = productName.count
        
        // フォントサイズを計算
        var fontSize = CGFloat(maxLength - productNameLength) * scaleFactor + 16 // デフォルトのフォントサイズ16
        if fontSize < CGFloat(minLength) {
            fontSize = CGFloat(minLength)
        }
        return fontSize
    }
    /*
    日付のフォーマットを変えるためのメソッド
     */
    private func FormatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd" // 新しい日付フォーマット
        if let date = dateFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        } else {
            return dateString // 日付の変換に失敗した場合は元の文字列を返す
        }
    }
    /*
      投稿画像をRealmから取得するためのメソッド
     */
    private func loadImage(for historyData: HistoryData) {
        let realm = try! Realm()
        let id = historyData.ID
        let realmImage = realm.objects(ImageRealm.self).filter("ID == %@", id)
        if let historyImage = realmImage.first, let imageData = historyImage.imageData {
            self.image = UIImage(data: imageData)
        }
    }
}

#Preview {
    RcHistoryView()
}

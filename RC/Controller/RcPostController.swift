//
//  RcPostController.swift
//  RC
//
//  Created by 酒匂竜也 on 2024/03/16.
//

import SwiftUI
import Alamofire
import RealmSwift

struct RcPostController: View {
    @State private var rcImage = Image(systemName: "cart.badge.plus")
    @State private var rcPostImage = Image(systemName: "photo.badge.plus")
    @State private var janlText: String = ""
    
    var body: some View {
        VStack(spacing:350) {
               rcPostImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.leading,40)
            VStack {
                TextField("ジャンル", text: $janlText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // 上部の余白を調整
                    .padding(.top,-350)
                // 横方向の余白を調整
                    .padding(.horizontal)
                // 下部の余白を調整
                    .padding(.bottom, 50)
                
                TextField("ジャンル", text: $janlText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // 上部の余白を調整
                    .padding(.top,-350)
                // 横方向の余白を調整
                    .padding(.horizontal)
                // 下部の余白を調整
                    .padding(.bottom, 50)
                
                TextField("ジャンル", text: $janlText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // 上部の余白を調整
                    .padding(.top,-350)
                // 横方向の余白を調整
                    .padding(.horizontal)
                // 下部の余白を調整
                    .padding(.bottom, 50)
            }
            
        }
       
    }
}

#Preview {
    RcPostController()
}

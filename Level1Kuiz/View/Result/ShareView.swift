//
//  ShareView.swift
//  Level1Kuiz
//
//  Created by hyunho lee on 2023/10/09.
//

import SwiftUI

struct ShareView: View {
    
    let score: String
    let rank: String
    let message: String
    
    var body: some View {
        ZStack {
            Color.yellow.ignoresSafeArea()
        VStack(alignment: .center, spacing: 8) {
            Text(score)
                .font(.system(size: 80))
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
            Text(rank)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            VStack(alignment: .leading, spacing: 12) {
                Text("\(message)")
                    .font(.title3)
                    .fontWeight(.heavy)
                
            }
            .margin(top: 40)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
    }
    }
}

#Preview {
    ShareView(score: "12", rank: "맞춤법 더듬이", message: "일반인 등급까지 10문제 남았어요")
}

import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return activityController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}

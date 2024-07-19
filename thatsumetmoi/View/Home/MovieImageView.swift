//
//  MovieImageView.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import SwiftUI
import Kingfisher

struct MovieImageView: View {
    let imageUrl: URL

    var body: some View {
        KFImage.url(imageUrl)
            .placeholder {
                ProgressView()
                    .frame(width: 100, height: 130)
            }
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 130)
            .cornerRadius(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 4)
            )
            .padding(3)
    }
}

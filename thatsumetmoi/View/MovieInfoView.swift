//
//  MovieInfoView.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import SwiftUI

struct MovieInfoView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
                .font(.headline)
                .lineLimit(1)
            HStack {
                Text(String(format: "%.0f%%", movie.voteAverage * 10))
                    .font(.subheadline)
                    .foregroundColor(movie.voteAverage >= 7 ? .green : movie.voteAverage >= 5 ? .yellow : .red)
                Text(movie.releaseDate)
                    .font(.subheadline)
            }
            Text(movie.overview)
                .font(.system(size: 13))
                .lineLimit(3)
        }
        .padding(.leading, 8)
    }
}

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
                CircularProgressView(progress: movie.voteAverage * 10, color: movie.voteAverage >= 7 ? .green : movie.voteAverage >= 5 ? .yellow : .red)
                    .frame(width: 40, height: 40)
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

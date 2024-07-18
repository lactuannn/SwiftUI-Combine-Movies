//
//  MovieRowView.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack {
            MovieImageView(imageUrl: movie.imageUrl)
            MovieInfoView(movie: movie)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}

//
//  CircularProgressView.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 19/7/24.
//

import SwiftUI

struct CircularProgressView: View {
    var progress: Double
    var color: Color

    @State private var animatedProgress: Double = 0.0

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4.0)
                .foregroundColor(color.opacity(0.3))

            Circle()
                .trim(from: 0.0, to: CGFloat(min(animatedProgress / 100.0, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))

            Text(String(format: "%.0f%%", min(progress, 100.0)))
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(color)
        }
        .frame(width: 36, height: 36)
        .onAppear {
            withAnimation(.linear(duration: 1.0)) {
                animatedProgress = progress
            }
        }
    }
}

#Preview {
    CircularProgressView(progress: 0.75, color: .green)
}

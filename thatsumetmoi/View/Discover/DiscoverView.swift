//
//  DiscoverView.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 19/7/24.
//

import SwiftUI
import Kingfisher


enum DayState {
    case love
    case poop
    case empty
}

struct Card: Identifiable {
    let id = UUID()
    let title: String
    let imageName: URL
}

struct DiscoverView: View {
    @State private var cards: [Card] = [
        Card(title: "Sample Title 1", imageName: URL(string: "https://i.pinimg.com/236x/96/94/59/9694599e65dc14df0541a344e20bda7b.jpg")!),
        Card(title: "Sample Title 2", imageName: URL(string: "https://i.pinimg.com/736x/36/ea/1b/36ea1b7131ce8fecf21b3a95d52fcea2.jpg")!),
        Card(title: "Sample Title 3", imageName: URL(string: "https://i.pinimg.com/736x/e9/39/07/e9390769fee00ac6a048afe264e83407.jpg")!),
        Card(title: "Sample Title 4", imageName: URL(string: "https://i.pinimg.com/736x/db/07/5e/db075e6e1f4739ee5c62d7238e521551.jpg")!),
    ]

    var body: some View {
        ZStack {
            ForEach(cards) { card in
                CardView(card: card) {
                    removeCard(card)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .stacked(at: cards.firstIndex(where: { $0.id == card.id })!, in: cards.count)
            }

            if let topCard = cards.first {
                VStack {
                    Spacer()
                    Text(topCard.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                }
            }
        }
    }

    private func removeCard(_ card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards.remove(at: index)
        }
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(CGSize(width: 0, height: offset * 20))
            .scaleEffect(CGSize(width: 1 - (offset * 0.05), height: 1 - (offset * 0.05)))
    }
}

enum AppColor: String
{
    case accent = "Accent"
    case primaryTextColor = "PrimaryTextColor"
    case cardShadow = "CardShadow"
}


#Preview {
    DiscoverView()
}

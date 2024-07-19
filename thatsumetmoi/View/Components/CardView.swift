//
//  CardView.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 19/7/24.
//
import SwiftUI
import Kingfisher

private struct CardViewConsts {
    static let cardRotLimit: CGFloat = 20.0
    static let poopTriggerZone: CGFloat = -0.1
    static let loveTriggerZone: CGFloat = 0.1

    static let cardRatio: CGFloat = 1.333
    static let cardCornerRadius: CGFloat = 24.0
    static let cardShadowOffset: CGFloat = 16.0
    static let cardShadowBlur: CGFloat = 16.0

    static let labelTextSize: CGFloat = 24.0
    static let labelTextKerning: CGFloat = 6.0

    static let motionRemapFromMin: Double = 0.0
    static let motionRemapFromMax: Double = 0.25
    static let motionRemapToMin: Double = 0.0
    static let motionRemapToMax: Double = 1.0

    static let springResponse: Double = 0.5
    static let springBlendDur: Double = 0.3

    static let iconSize: CGSize = CGSize(width: 96.0, height: 96.0)
}

struct CardView: View {
    var card: Card
    var onRemove: () -> Void

    @State private var translation: CGSize = .zero
    @State private var motionOffset: Double = 0.0
    @State private var motionScale: Double = 0.0
    @State private var lastCardState: DayState = .empty
    @State private var isRemoved: Bool = false
    @State private var cardAlpha: Double = 1.0

    private func getIconName(state: DayState) -> String {
        switch state {
        case .love: return "Love"
        case .poop: return "Poop"
        default: return "Empty"
        }
    }

    private func setCardState(offset: CGFloat) -> DayState {
        if offset <= CardViewConsts.poopTriggerZone { return .poop }
        if offset >= CardViewConsts.loveTriggerZone { return .love }
        return .empty
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                KFImage.url(card.imageName)
                    .placeholder {
                        ProgressView()
                            .frame(width: 100, height: 130)
                    }
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width - 10, height: geometry.size.width * CardViewConsts.cardRatio - 10)
                    .cornerRadius(CardViewConsts.cardCornerRadius)
                    .clipped()

                VStack {
                    Spacer()
                    Image(getIconName(state: self.lastCardState))
                        .frame(width: CardViewConsts.iconSize.width, height: CardViewConsts.iconSize.height)
                        .opacity(self.motionScale)
                        .scaleEffect(CGFloat(self.motionScale))
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width * CardViewConsts.cardRatio)
            .background(Color.white)
            .cornerRadius(CardViewConsts.cardCornerRadius)
            .shadow(
                color: Color(AppColor.cardShadow.rawValue),
                radius: CardViewConsts.cardShadowBlur,
                x: 0,
                y: CardViewConsts.cardShadowOffset
            )
            .rotationEffect(
                .degrees(Double(self.translation.width / geometry.size.width * CardViewConsts.cardRotLimit)),
                anchor: .bottom
            )
            .offset(x: self.translation.width, y: self.translation.height)
            .opacity(self.isRemoved ? 0 : self.cardAlpha)
            .animation(.interactiveSpring(
                response: CardViewConsts.springResponse,
                blendDuration: CardViewConsts.springBlendDur)
            )
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.translation = gesture.translation
                        self.cardAlpha = 1.0 - Double(abs(gesture.translation.width) / geometry.size.width)
                        self.motionOffset = Double(gesture.translation.width / geometry.size.width)
                        self.motionScale = Double.remap(
                            from: self.motionOffset,
                            fromMin: CardViewConsts.motionRemapFromMin,
                            fromMax: CardViewConsts.motionRemapFromMax,
                            toMin: CardViewConsts.motionRemapToMin,
                            toMax: CardViewConsts.motionRemapToMax
                        )
                        self.lastCardState = setCardState(offset: gesture.translation.width)
                    }
                    .onEnded { gesture in
                        if abs(gesture.translation.width) > 150 {
                            withAnimation {
                                self.translation = CGSize(width: gesture.translation.width * 2, height: 0)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.isRemoved = true
                                onRemove()
                            }
                        } else {
                            self.translation = .zero
                            self.motionScale = 0.0
                            self.cardAlpha = 1.0
                        }
                    }
            )
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

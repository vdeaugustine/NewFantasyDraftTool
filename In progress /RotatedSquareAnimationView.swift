//
//  RotatedSquareAnimationView.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/25/23.
//

import SwiftUI


struct BaseballDiamondAnimationView: View {
    @State private var animationProgress: CGFloat = 0.0
    let sideLength: CGFloat = 100

    var body: some View {
        
        Color.cyan
//            let diamondPath = createBaseballDiamondPath(sideLength: sideLength)
//
//            diamondPath
//                .trim(from: 0, to: animationProgress)
//                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
//                .foregroundColor(.blue)
//                .frame(width: sideLength, height: sideLength)
//                .onAppear {
//                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
//                        animationProgress = 1.0
//                    }
//                }
        
    }

    private func createBaseballDiamondPath(sideLength: CGFloat) -> Path {
        Path { path in
            let startingPoint = CGPoint(x: sideLength / 2, y: 0)

            path.move(to: startingPoint)
            path.addLine(to: CGPoint(x: sideLength, y: sideLength / 2))
            path.addLine(to: CGPoint(x: sideLength / 2, y: sideLength))
            path.addLine(to: CGPoint(x: 0, y: sideLength / 2))
            path.addLine(to: startingPoint)

            // First base
            path.addLine(to: CGPoint(x: sideLength * 3 / 4, y: sideLength / 4))

            // Second base
            path.addLine(to: CGPoint(x: sideLength / 2, y: sideLength / 2))

            // Third base
            path.addLine(to: CGPoint(x: sideLength / 4, y: sideLength / 4))

            // Home plate
            path.addLine(to: startingPoint)
        }
    }
}

struct BaseballDiamondAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        BaseballDiamondAnimationView()
            .frame(width: 200, height: 200)
            .previewLayout(.sizeThatFits)
    }
}



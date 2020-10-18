//
//  Line.swift
//  Graph
//
//  Created by Patrick Maltagliati on 10/17/20.
//

import SwiftUI

struct Line: Shape {
    var from: CGPoint
    var to: CGPoint
    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData> {
        get { AnimatablePair(from.animatableData, to.animatableData) }
        set {
            from.animatableData = newValue.first
            to.animatableData = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: from)
            p.addLine(to: to)
        }
    }
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            Line(
                from: geo.frame(in: .global).origin,
                to: CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            )
            .stroke(lineWidth: 3)
            .foregroundColor(.blue)
        }
    }
}

//
//  AppleLogo.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import SwiftUI

struct GoogleLogo: SVGIcon {

  static let intrinsicSize = CGSize(width: 800, height: 800)
  static let viewBox = CGRect(x: 0.0, y: 0.0, width: 210, height: 210)

  struct PathView1: View { // SVGPath

    struct PathShape1: Shape {

      func path(in rect: CGRect) -> Path {
        Path { path in
          path.move(to: CGPoint(x: 0, y: 105))
          path.addCurve(to: CGPoint(x: 105, y: 0),
                        control1: CGPoint(x: 0, y: 47.103),
                        control2: CGPoint(x: 47.103, y: 0))
          path.addCurve(to: CGPoint(x: 169.004, y: 21.756),
                        control1: CGPoint(x: 128.383, y: 0),
                        control2: CGPoint(x: 150.515, y: 7.523))
          path.addLine(to: CGPoint(x: 144.604, y: 53.452))
          path.addCurve(to: CGPoint(x: 105, y: 40),
                        control1: CGPoint(x: 133.172, y: 44.652),
                        control2: CGPoint(x: 119.477, y: 40))
          path.addCurve(to: CGPoint(x: 40, y: 105),
                        control1: CGPoint(x: 69.159, y: 40),
                        control2: CGPoint(x: 40, y: 69.159))
          path.addCurve(to: CGPoint(x: 105, y: 170),
                        control1: CGPoint(x: 40, y: 140.841),
                        control2: CGPoint(x: 69.159, y: 170))
          path.addCurve(to: CGPoint(x: 166.852, y: 125),
                        control1: CGPoint(x: 133.867, y: 170),
                        control2: CGPoint(x: 158.398, y: 151.087))
          path.addLine(to: CGPoint(x: 105, y: 125))
          path.addLine(to: CGPoint(x: 105, y: 85))
          path.addLine(to: CGPoint(x: 210, y: 85))
          path.addLine(to: CGPoint(x: 210, y: 105))
          path.addCurve(to: CGPoint(x: 105, y: 210),
                        control1: CGPoint(x: 210, y: 162.897),
                        control2: CGPoint(x: 162.897, y: 210))
          path.addCurve(to: CGPoint(x: 0, y: 105),
                        control1: CGPoint(x: 47.103, y: 210),
                        control2: CGPoint(x: 0, y: 162.897))
          path.closeSubpath()
        }
      }
    }

    var body: some View {
      PathShape1()
            .fill(.tint)
    }
  }

  var isResizable = false
  func resizable() -> Self { Self(isResizable: true) }

  var body: some View {
    if isResizable {
      GeometryReader { proxy in
        PathView1()
          .frame(width: Self.viewBox.width, height: Self.viewBox.height,
                 alignment: .topLeading)
          .scaleEffect(x: proxy.size.width  / Self.viewBox.width,
                       y: proxy.size.height / Self.viewBox.height)
          .frame(width: proxy.size.width, height: proxy.size.height)
      }
    }
    else {
      PathView1()
        .frame(width: 800, height: 800)
    }
  }
}

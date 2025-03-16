//
//  AppleLogo.swift
//  photo-club
//
//  Created by Morris Richman on 3/15/25.
//

import Foundation
import SwiftUI

protocol SVGIcon: View {
    var isResizable: Bool { get }
    func resizable() -> Self
}

struct AppleLogo: SVGIcon {

  static let intrinsicSize = CGSize(width: 814, height: 1000)

  struct PathView1: View { // SVGPath

    struct PathShape1: Shape {

      func path(in rect: CGRect) -> Path {
        Path { path in
          path.move(to: CGPoint(x: 788.1, y: 340.9))
          path.addCurve(to: CGPoint(x: 679.9, y: 531.4),
                        control1: CGPoint(x: 782.3, y: 345.4),
                        control2: CGPoint(x: 679.9, y: 403.1))
          path.addCurve(to: CGPoint(x: 814.1, y: 733.6),
                        control1: CGPoint(x: 679.9, y: 679.8),
                        control2: CGPoint(x: 810.2, y: 732.3))
          path.addCurve(to: CGPoint(x: 745.4, y: 875.5),
                        control1: CGPoint(x: 813.5, y: 736.8),
                        control2: CGPoint(x: 793.4, y: 805.5))
          path.addCurve(to: CGPoint(x: 589.9, y: 998.6),
                        control1: CGPoint(x: 702.6, y: 937.1),
                        control2: CGPoint(x: 657.9, y: 998.6))
          path.addCurve(to: CGPoint(x: 425.9, y: 959.1),
                        control1: CGPoint(x: 521.9, y: 998.6),
                        control2: CGPoint(x: 504.4, y: 959.1))
          path.addCurve(to: CGPoint(x: 260, y: 999.9),
                        control1: CGPoint(x: 349.4, y: 959.1),
                        control2: CGPoint(x: 322.2, y: 999.9))
          path.addCurve(to: CGPoint(x: 104.5, y: 872.9),
                        control1: CGPoint(x: 197.8, y: 999.9),
                        control2: CGPoint(x: 154.4, y: 942.9))
          path.addCurve(to: CGPoint(x: 0, y: 541.8),
                        control1: CGPoint(x: 46.7, y: 790.7),
                        control2: CGPoint(x: 0, y: 663))
          path.addCurve(to: CGPoint(x: 250.8, y: 244.3),
                        control1: CGPoint(x: 0, y: 347.4),
                        control2: CGPoint(x: 126.4, y: 244.3))
          path.addCurve(to: CGPoint(x: 413.5, y: 287.7),
                        control1: CGPoint(x: 316.9, y: 244.3),
                        control2: CGPoint(x: 372, y: 287.7))
          path.addCurve(to: CGPoint(x: 589.8, y: 241.7),
                        control1: CGPoint(x: 453, y: 287.7),
                        control2: CGPoint(x: 514.6, y: 241.7))
          path.addCurve(to: CGPoint(x: 788.1, y: 340.9),
                        control1: CGPoint(x: 618.3, y: 241.7),
                        control2: CGPoint(x: 720.7, y: 244.3))
          path.closeSubpath()

          path.move(to: CGPoint(x: 554.1, y: 159.4))
          path.addCurve(to: CGPoint(x: 607.2, y: 20.1),
                        control1: CGPoint(x: 585.2, y: 122.5),
                        control2: CGPoint(x: 607.2, y: 71.3))
          path.addCurve(to: CGPoint(x: 605.3, y: -0),
                        control1: CGPoint(x: 607.2, y: 13),
                        control2: CGPoint(x: 606.6, y: 5.8))
          path.addCurve(to: CGPoint(x: 458.2, y: 75.8),
                        control1: CGPoint(x: 554.7, y: 1.9),
                        control2: CGPoint(x: 494.5, y: 33.7))
          path.addCurve(to: CGPoint(x: 403.1, y: 211.3),
                        control1: CGPoint(x: 429.7, y: 108.2),
                        control2: CGPoint(x: 403.1, y: 159.4))
          path.addCurve(to: CGPoint(x: 405, y: 229.4),
                        control1: CGPoint(x: 403.1, y: 219.1),
                        control2: CGPoint(x: 404.4, y: 226.9))
          path.addCurve(to: CGPoint(x: 418.6, y: 230.7),
                        control1: CGPoint(x: 408.2, y: 230),
                        control2: CGPoint(x: 413.4, y: 230.7))
          path.addCurve(to: CGPoint(x: 554.1, y: 159.4),
                        control1: CGPoint(x: 464, y: 230.7),
                        control2: CGPoint(x: 521.1, y: 200.3))
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
    let height: CGFloat = 1000
    let width: CGFloat = 1000

  var body: some View {
    if isResizable {
      GeometryReader { proxy in
        PathView1()
          .frame(width: width, height: height,
                 alignment: .topLeading)
          .scaleEffect(x: proxy.size.width  / width,
                       y: proxy.size.height / height)
          .frame(width: proxy.size.width, height: proxy.size.height)
      }
    }
    else {
      PathView1()
        .frame(width: width, height: height)
    }
  }
}

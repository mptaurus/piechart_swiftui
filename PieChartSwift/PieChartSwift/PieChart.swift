//
//  PiezChart.swift
// 
//
//  Created by Marek Porowski on 24/04/2020.
//  Copyright © 2020 Marek Porowski. All rights reserved.
//

import SwiftUI

struct PieChart: View {
    
    @Binding var bangle: [Double]
    @State var isShowing  = false
    
    func computeOne360 (angle: Double) -> Double {
        
        let all = bangle.reduce(0) {return $0 + $1}
        
        guard all > 0  else {
              return 0
            }
       return (angle * 360.0) / all
    }
    
    func computeRotationAngle(number: Int) -> Double {

        var  angle : Double = 0
        
        guard number != 0 else { return 0 }
        
        for i in 0..<number {
            
            angle += computeOne360(angle: bangle[i])
        }
        return angle
    }
    
    var body: some View {
        
        ZStack {
        
            Circle().stroke(Color.white, lineWidth: 1.0)
            GeometryReader { geometry in
            ForEach( 0..<self.bangle.count ) { i in
                
            Path { path in
                let minSize = min(geometry.size.width, geometry.size.height)
                let maxSize = max(geometry.size.width, geometry.size.height)
                let center: CGPoint = .init(x: minSize / 2, y: maxSize / 2)
                
                path.move(to: .init(x: center.x, y: center.y))
                path.addArc(center: center, radius: center.x - 0.05 * center.x, startAngle: .degrees(0), endAngle: .degrees(self.computeOne360(angle: self.bangle[i])), clockwise: false)
                }
                
            .fill(Color.pieColors[i] )
            .opacity(self.isShowing ? 1 : 0.0)
            .scaleEffect(self.isShowing ? 1 : 0.0)
            .rotationEffect(.degrees (self.isShowing ? self.computeRotationAngle(number: i) : 0), anchor: UnitPoint(x: 0.5, y: 0.5))
            .animation(.easeInOut(duration: 0.35))
            }
            }
            Circle()
                .frame(width: 10.0, height: 10.0)
                .shadow(radius: 10)
                .foregroundColor(.black)
        }.aspectRatio(1, contentMode: .fit)
        
     .onAppear() {
        self.isShowing = true
        }
        
  }
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChart(bangle: .constant([11,22,3,4,5,6]))
    }
}

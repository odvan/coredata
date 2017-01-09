//
//  StatChartView.swift
//  Second
//
//  Created by Artur Kablak on 04/12/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit
import CoreData

class StatChartView: UIView {
    
    var context: NSManagedObjectContext? = ((UIApplication.shared.delegate) as? AppDelegate)?.persistentContainer.viewContext
    
    var chartElements = [Int]()
    
    
    private func chartElementsFetch() {
        
        chartElements = []
        
        let request = NSFetchRequest<HeartRate>(entityName: "HeartRate")
        
        let timeSortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        request.sortDescriptors = [timeSortDescriptor]
        request.fetchLimit = 30
//        request.resultType = .dictionaryResultType
//        request.propertiesToFetch = ["rate"]
        
        do {
            
            let result = try context!.fetch(request)
                        
            for element in result {
                
                chartElements.append(Int(element.rate))
                print("\(element.rate)")
            }
        } catch {
                print("error in chartElementsFetch")
            }
        }

    private func gradientColorBackground() {
        let startColor: UIColor = UIColor(red: 243/255, green: 113/255, blue: 90/255, alpha: 1.0)
        let endColor: UIColor = UIColor.orange
        
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)
        
        //6 - draw the gradient
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y:self.bounds.height)
        context!.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: CGGradientDrawingOptions(rawValue: 0))
        
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let width = rect.width
        let height = rect.height

        gradientColorBackground()
        
        chartElementsFetch()
        
        
        // Calculate the X-point
        
        let margin: CGFloat = 12.0
        let columnXPoint = { (column: Int) -> CGFloat in
            // Calculate gap between points
            let spacer = (width - margin*2) / CGFloat((self.chartElements.count - 1))
            var x: CGFloat = CGFloat(column) * spacer
            x += margin
            return x
        }
        
        // Calculate the Y-point
        
        let topBorder: CGFloat = 20
        let bottomBorder: CGFloat = 20
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = chartElements.max()
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            var y: CGFloat = CGFloat(graphPoint) /
                CGFloat(maxValue!) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        
        // Draw the line graph
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        // Set up the points line
        let graphPath = UIBezierPath()
        // Go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0),
                                      y: columnYPoint(chartElements[29])))
        graphPath.addLine(to: CGPoint(x: columnXPoint(0), y: height - bottomBorder))
        
        // Add lines for each item in the chartElements array
        // At the correct (x, y) for the point
        for i in 1..<chartElements.count {
            let nextColumn = CGPoint(x: columnXPoint(i),
                                    y: columnYPoint(chartElements[chartElements.count - i - 1]))
            graphPath.move(to: nextColumn)
            graphPath.addLine(to: CGPoint(x: columnXPoint(i), y: height - bottomBorder))
        }
        
        graphPath.lineWidth = 4
        graphPath.lineCapStyle = .round
        graphPath.stroke()
        
        // Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        // Top line
        linePath.move(to: CGPoint(x: margin, y: topBorder - 2))
        linePath.addLine(to: CGPoint(x: width - margin,
                                        y: topBorder - 2))
        
        // Center line
//        linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
//        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        
        // Bottom line
        linePath.move(to: CGPoint(x: margin, y: height - bottomBorder + 2))
        linePath.addLine(to: CGPoint(x: width - margin, y:height - bottomBorder + 2))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()

    }
 

}

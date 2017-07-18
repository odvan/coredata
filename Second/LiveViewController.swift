//
//  ViewController.swift
//  Second
//
//  Created by Artur Kablak on 21/11/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit
import CoreData

class LiveViewController: UIViewController {
    
    // MARK: Constants and variables
    
    var shapeView = ShapeView()
    var randomNumber: CGFloat?
        
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    var context: NSManagedObjectContext? = ((UIApplication.shared.delegate) as? AppDelegate)?.persistentContainer.viewContext
    
    @IBOutlet weak var pulseSlider: UISlider!
    
    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 243/255, green: 113/255, blue: 90/255, alpha: 1.0) //UIColor(red: 255/255, green: 160/255, blue: 220/255, alpha: 1.0)
        setupShapeView()
        
        let ti = 60
        Timer.scheduledTimer(timeInterval: TimeInterval(ti), target: self, selector: #selector(LiveViewController.addHeartRateIntoArray), userInfo: nil, repeats: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewDidAppear")
        randomNumber = CGFloat(arc4random_uniform(10) + 5)
        
        smoothAnimation(some: randomNumber!)
        
    }

    private func setupShapeView() {
        
        view.addSubview(shapeView)
        
        //simpleRing.backgroundColor = UIColor(red: 0, green: 0.7, blue: 1, alpha: 1)
        shapeView.isOpaque = false
        
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        
        shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        shapeView.widthAnchor.constraint(equalToConstant: min(view.bounds.size.width, view.bounds.size.height)*0.8).isActive = true
        shapeView.heightAnchor.constraint(equalTo: shapeView.widthAnchor).isActive = true
        //shapeView.alpha = 0
        
    }
    
    private func smoothAnimation(some number: CGFloat) {

        UIView.animate(withDuration: 30, delay: 2, options: [.autoreverse, .repeat], animations:
            { self.shapeView.transform = self.randomAnimation(number: number)
                print("animation started")

        },
                       completion: { finished in
                        self.shapeView.transform = CGAffineTransform.identity
//if current vc is liveview ... start animation
                        print("animation completed")
        })
        
    }
    
    private func randomAnimation(number: CGFloat) -> CGAffineTransform {
        
        let transformKind = arc4random() % 3
        var kind: CGAffineTransform!
        
        switch transformKind {
        case 0:
            kind = CGAffineTransform(scaleX: (100 + number)/100, y: (100 + number)/100)
            kind = kind?.rotated(by: number * CGFloat(M_PI/180))
        case 1:
            kind = CGAffineTransform(translationX: number + 5, y: number - 20)
            kind = kind?.rotated(by: number * CGFloat(M_PI/180))
        case 2:
            kind = CGAffineTransform(rotationAngle: number * CGFloat(M_PI/180))
        default:
            print("error")
        }
        return kind
    }
    
    @IBAction func heartBitsChanging(_ sender: UISlider) {
        
        shapeView.bits = Int(self.pulseSlider.value)
        shapeView.setNeedsDisplay()
        
        shapeView.transform = CGAffineTransform.identity
        self.shapeView.layer.removeAllAnimations()
        
//        if (!pulseSlider.isTracking) {
//            print("stopped dragging slider")
//            
////            shapeView.transform = CGAffineTransform.identity
////            self.shapeView.layer.removeAllAnimations()
//            
//            randomNumber = CGFloat(arc4random_uniform(10) + 5)
//            //        print(randomNumber!)
//            smoothAnimation(some: randomNumber!)
//        
//        }
    }
    
    
    
    @objc private func addHeartRateIntoArray() {
        
        //        heartModel.heartRate += [shapeView.bits!]
        //        print(heartModel.heartRate)
        
        let heartRate = HeartRate(context: context!)
        
        heartRate.rate = Int32(pulseSlider.value)
        heartRate.time = NSDate()
        
        appDelegate.saveContext()
        
        print("rate: \(heartRate.rate), time: \(heartRate.time)")
        
        heartRateStat()
        
    }
    
    private func heartRateStat() {
        
        context?.perform {
            let stat = try? self.context?.count(for: NSFetchRequest(entityName: "HeartRate"))
            print("\(stat!) records to date")
        }
        
        do {
            let request = NSFetchRequest<HeartRate>(entityName: "HeartRate")
            let result = try context!.fetch(request)
            
            for element in result {
                print("\(element.rate)")
            }

        } catch {
            print("error")
        }
        
    }
}


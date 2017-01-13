//
//  ParentViewController.swift
//  Second
//
//  Created by Artur Kablak on 14/12/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

    enum TabIndex: Int {
        case FirstChildTab = 0
        case SecondChildTab = 1
    }
    
    var currentViewController: UIViewController?
    var firstChildTabVC : UIViewController?
    var secondChildTabVC : UIViewController?
    
    @IBOutlet weak var segmentedSwitch: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        segmentedSwitch.selectedSegmentIndex = TabIndex.FirstChildTab.rawValue
        displayCurrentTab(tabIndex: TabIndex.FirstChildTab.rawValue)
        
    }
    
    // MARK: Switching Tab Functions
    
    @IBAction func switchTabs(sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(tabIndex: sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(index: tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
            //vc.viewWillAppear(true)
        }
    }
    
    func viewControllerForSelectedSegmentIndex(index: Int) -> UIViewController? {
        
        var vc: UIViewController?
        
        switch index {
        case TabIndex.FirstChildTab.rawValue:
            if firstChildTabVC == nil {
                firstChildTabVC = (self.storyboard?.instantiateViewController(withIdentifier: "FirstChildViewController"))! as UIViewController
            }
            vc = firstChildTabVC
            
        case TabIndex.SecondChildTab.rawValue:
            if secondChildTabVC == nil {
                secondChildTabVC = (self.storyboard?.instantiateViewController(withIdentifier: "SecondChildViewController"))! as UIViewController
            }
            vc = secondChildTabVC
            
        default:
            return nil
        }
        
        return vc
    }


}

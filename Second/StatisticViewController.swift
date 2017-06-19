//
//  StatisticViewController.swift
//  Second
//
//  Created by Artur Kablak on 01/12/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit
import CoreData

class StatisticViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Constants and variables
    
    @IBOutlet weak var statTable: UITableView!
    @IBOutlet weak var statChart: StatChartView!
    
    @IBOutlet weak var min: UILabel!
    @IBOutlet weak var max: UILabel!
    @IBOutlet weak var avg: UILabel!
    @IBOutlet weak var max_column: UILabel!
    @IBOutlet weak var min_column: UILabel!
    
    var context: NSManagedObjectContext? = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<HeartRate>?
    
    var labelsElements = [Int]()
    
    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        statTable.dataSource = self
        statTable.delegate = self
        
        initializeFetchedResultsController()
        
        labelsSetup()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Method for initializing FetchedResultsController
    
    @objc private func initializeFetchedResultsController() {
        
        let request = NSFetchRequest<HeartRate>(entityName: "HeartRate")
        let time = NSSortDescriptor(key: "time", ascending: false)
        request.sortDescriptors = [time]
        
        //let moc = context
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    private func changeDateFormat(date: NSDate) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let text = dateFormatter.string(from: date as Date)
        
        return text
    }
    
    
    func labelsSetup() { // seems excessive cause it doubling fetch request in StatChartView: DONE!
        
        labelsElements = []
        
        let request = NSFetchRequest<HeartRate>(entityName: "HeartRate")
        
        let timeSortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        request.sortDescriptors = [timeSortDescriptor]
        request.fetchLimit = 30
        
        do {
            
            let result = try context!.fetch(request)
            
            for element in result {
                
                labelsElements.append(Int(element.rate))
                print("\(element.rate)")
            }
        } catch {
            print("error in chartElementsFetch")
        }

        if labelsElements.count > 0 {
            
            statChart.chartElements = labelsElements // sending fetched data to StatChartView
            
            min.text = "Min: \(labelsElements.min()!)"
            max.text = "Max: \(labelsElements.max()!)"
            
            var average = labelsElements.reduce(0) { (total: Int, next: Int) -> Int in
                return total + next
            }
            average = average / labelsElements.count
            avg.text = "Avg: \(average)"
            
            min_column.text = "0"
            max_column.text = "\(labelsElements.max()!)"
            
        }
        
        
    }
    
    
    // MARK: Table methods
    
    func configureCell(cell: UITableViewCell, withObject heart: HeartRate) {
        cell.textLabel?.text = String(heart.rate)
        cell.detailTextLabel?.text = changeDateFormat(date: heart.time!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statTable.dequeueReusableCell(withIdentifier: "statCell", for: indexPath)
        
        if let dataStat = fetchedResultsController?.object(at: indexPath) {
            configureCell(cell: cell, withObject: dataStat)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "heart rate"
    }
    
    
    
}

// MARK: NSFetchedResultsControllerDelegate methods

extension StatisticViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        statTable.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            statTable.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            statTable.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }

    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                statTable.insertRows(at: [indexPath as IndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let dataStat = (fetchedResultsController?.object(at: indexPath as IndexPath))! as HeartRate
                guard let cell = statTable.cellForRow(at: indexPath as IndexPath) else { break }
                configureCell(cell: cell, withObject: dataStat)
            }
        case .move:
            if let indexPath = indexPath {
                statTable.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                statTable.insertRows(at: [newIndexPath as IndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                statTable.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        statTable.endUpdates()
        labelsSetup()
        statChart.setNeedsDisplay()

    }

}

//
//  PromiseListViewController.swift
//  Promissing
//
//  Created by hPark_ipl on 2017. 5. 5..
//  Copyright © 2017년 hPark. All rights reserved.
//

import UIKit
import CoreData

class PromiseListViewController: UIViewController, UIViewControllerTransitioningDelegate, NSFetchedResultsControllerDelegate {

    var selectedButton: UIButton!
    let animator = ExpandingAnimator()

    @IBOutlet weak var promiseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promiseTableView.delegate = self
        promiseTableView.dataSource = self
    }
    
    var fetchedResultsController: NSFetchedResultsController<Promise> {
        guard _fetchedResultsController == nil else {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Promise> = Promise.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "promisedAt", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Promise>? = nil

    @IBAction func handleButtonAction(_ sender: UIButton) {
        selectedButton = sender
        if selectedButton.tag == 1 {
            self.performSegue(withIdentifier: Constants.Segue.listToRecord , sender: nil)
        } else {
            self.performSegue(withIdentifier: Constants.Segue.toCalendar , sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let calendarViewController = segue.destination as? CalendarViewController {
            calendarViewController.transitioningDelegate = self
            calendarViewController.modalPresentationStyle = .custom
        } else if let recordViewController = segue.destination as? RecordPromiseViewController {
            recordViewController.transitioningDelegate = self
            recordViewController.modalPresentationStyle = .custom
        }
    }
    
    func setAnimator(mode: ExpandingAnimator.TransitionMode) -> UIViewControllerAnimatedTransitioning? {
        animator.transitionMode = mode
        animator.origin = selectedButton.center
        animator.circleColor = selectedButton.tintColor!
        return animator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return setAnimator(mode: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return setAnimator(mode: .dismiss)
    }
}


extension PromiseListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromiseCell", for: indexPath)
        cell.textLabel?.text = self.fetchedResultsController.object(at: indexPath).content
        return cell
    }
}

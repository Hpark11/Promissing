//
//  CalendarViewController.swift
//  Promissing
//
//  Created by hPark_ipl on 2017. 5. 5..
//  Copyright © 2017년 hPark. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var selectedButton: UIButton!
    let animator = ExpandingAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleButtonTapped(_ sender: UIButton) {
        selectedButton = sender
        if selectedButton.tag == 1 {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: Constants.Segue.calendarToRecord , sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recordViewController = segue.destination as? RecordPromiseViewController {
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

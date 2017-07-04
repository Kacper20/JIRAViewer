//
//  LoadingViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 03/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//
import Foundation

class LoadingContainerViewController: NSViewController {

    var presentedVC: NSViewController?

    init() {
        super.init(nibName: nil, bundle: nil)!
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func presentViewController(_ newVC: NSViewController) {
        let oldVC = presentedVC
        presentedVC = newVC
        if let oldVC = oldVC {
            addNewViewControllerAsMain(newVC)
            newVC.view.alphaValue = 0
            Animation.animate(with: 0.4, animations: {
                newVC.view.alphaValue = 1.0
                oldVC.view.alphaValue = 0.0
            }, completion: {
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            })
        } else {
            addNewViewControllerAsMain(newVC)
        }
    }

    private func addNewViewControllerAsMain(_ newVC: NSViewController) {
        addChildViewController(newVC)
        view.addSubview(newVC.view)
        newVC.view.constraintEdgesToSuperview()
    }
}

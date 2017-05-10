//
//  LoginFlowContainerViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class LoginFlowContainerViewController: NSViewController {

    private let teamPickerVc: TeamPickerViewController

    init() {
        teamPickerVc = TeamPickerViewController(viewModel: TeamPickerViewModel())
        super.init(nibName: nil, bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(teamPickerVc)
        view.addSubview(teamPickerVc.view)
        teamPickerVc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

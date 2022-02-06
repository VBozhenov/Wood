//
//  MainPresenter.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 26.01.2022.
//

import UIKit
import RxSwift

class MainPresenter {
    weak var mainViewController: MainViewController?
    private var disposeBag = DisposeBag()
    
    func viewIsReady() {
        mainViewController?.startButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let mainViewController = self.mainViewController else { return }
                mainViewController.delegate?.mainViewControllerDidPressStart(mainViewController)
            })
            .disposed(by: disposeBag)
    }
}

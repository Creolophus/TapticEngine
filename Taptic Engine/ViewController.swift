//
//  ViewController.swift
//  Taptic Engine
//
//  Created by TaoLiang on 2019/11/13.
//  Copyright © 2019 Creolophus. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var buttons : [UIButton]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let data : [(color: UIColor, feedbackType: UINotificationFeedbackGenerator.FeedbackType, title: String)] = [
            (.systemGreen, .success, "success"),
            (.systemYellow, .warning, "warning"),
            (.systemRed, .error, "error")]
        
        buttons = data.map { (tuple) -> UIButton in
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 40
            button.backgroundColor = tuple.color
            button.setTitleColor(UIColor.reverseLabel, for: .normal)
            button.tag = tuple.feedbackType.rawValue
            button.setTitle(tuple.title, for: .normal)
            button.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
            return button
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons!)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            maker.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(100)
        }
        
        for button in buttons! {
            button.snp.makeConstraints { (maker) in
                maker.size.equalTo(CGSize(width: 80, height: 80))
            }
        }
    }
    
    
    @objc func onTapped(button: UIButton) {
        let gen = UINotificationFeedbackGenerator()
        gen.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType(rawValue: button.tag) ?? .success)
    }
}


extension UIColor {
    static var reverseLabel: UIColor {
            if #available(iOS 13, *) {
                return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .dark {
                        return UIColor.white
                    } else {
                        return UIColor.darkText
                    }
                }
            } else {
                return UIColor.darkText
            }
        }
}



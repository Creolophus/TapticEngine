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
    
    var feedbackButtons : [UIButton] = []
    let notiData : [(color: UIColor, feedbackType: UINotificationFeedbackGenerator.FeedbackType, title: String)] = [
        (.systemGreen, .success, "success"),
        (.systemYellow, .warning, "warning"),
        (.systemRed, .error, "error")]

    let impactData : [(color: UIColor, feedbackType: UIImpactFeedbackGenerator.FeedbackStyle, title: String)] = [
        (.tertiaryLabel, .light, "light"),
        (.secondaryLabel, .medium, "medium"),
        (.label, .heavy, "heavy")]

    
    let notiBtn = UIButton(type: .system)
    let impactBtn = UIButton(type: .system)
    var triggers = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        feedbackButtons = notiData.map { (tuple) -> UIButton in
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 40
            button.backgroundColor = tuple.color

            button.tag = tuple.feedbackType.rawValue
            button.setTitle(tuple.title, for: .normal)
            button.addTarget(self, action: #selector(onFeedbackTapped), for: .touchUpInside)
            return button
        }
        
        let notiStackView = UIStackView(arrangedSubviews: feedbackButtons)
        notiStackView.axis = .horizontal
        notiStackView.distribution = .equalSpacing
        notiStackView.alignment = .center
        
        view.addSubview(notiStackView)
        notiStackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            maker.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
            maker.centerY.equalToSuperview()
        }
        
        for button in feedbackButtons {
            button.snp.makeConstraints { (maker) in
                maker.size.equalTo(CGSize(width: 80, height: 80))
                maker.top.bottom.equalToSuperview()
            }
        }
        
        
        notiBtn.isSelected = true
        notiBtn.setTitle("UINotificationFeedbackGenerator", for: .normal)
        notiBtn.tag = 0
        notiBtn.addTarget(self, action: #selector(onTrigger(button:)), for: .touchUpInside)
        
        impactBtn.setTitle("UIImpactFeedbackGenerator", for: .normal)
        impactBtn.tag = 1
        impactBtn.addTarget(self, action: #selector(onTrigger(button:)), for: .touchUpInside)
        
        triggers = [notiBtn, impactBtn]

        let triggerStackView = UIStackView(arrangedSubviews: triggers)
        triggerStackView.axis = .vertical
        triggerStackView.distribution = .equalSpacing
        triggerStackView.alignment = .center
        triggerStackView.spacing = 15
        view.addSubview(triggerStackView)
        triggerStackView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            maker.left.right.equalToSuperview()
        }
        
    }
    
}


extension ViewController {
    @objc func onTrigger(button: UIButton) {
        guard button.isSelected == false else {
            return
        }
        updateTriggers()
        updateFeedbackButtons(tag: button.tag)
    }
    
    func updateTriggers() {
        _ = triggers.map({ $0.isSelected = !$0.isSelected })
    }
    
    func updateFeedbackButtons(tag: Int) {
        
        for (i, button) in feedbackButtons.enumerated() {
            button.backgroundColor = tag == 0 ? notiData[i].color : impactData[i].color
            button.setTitle(tag == 0 ? notiData[i].title : impactData[i].title, for: .normal)
        }
    }
}

extension ViewController {
    
    @objc func onFeedbackTapped(button: UIButton) {
        if notiBtn.isSelected {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType(rawValue: button.tag) ?? .success)
        }else if impactBtn.isSelected {
            let gen = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle(rawValue: button.tag) ?? .light)
            gen.prepare()
            gen.impactOccurred()

        }
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



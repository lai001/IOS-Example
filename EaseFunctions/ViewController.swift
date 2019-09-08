//
//  ViewController.swift
//  EaseFunctions
//
//  Created by lai001 on 2019/9/8.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Identifier")
        return tableview
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("clear", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(clearButtonTap), for: .touchUpInside)
        return button
    }()
    
    let animationView: AnimationView = AnimationView()
    
    lazy var data: [[(CGFloat) -> CGFloat]] = {
        var data: [[(CGFloat) -> CGFloat]] = []
        data.append([AnimationFormula.Quadratic().easeIn, AnimationFormula.Quadratic().easeOut, AnimationFormula.Quadratic().easeInOut])
        data.append([AnimationFormula.Cubic().easeIn, AnimationFormula.Cubic().easeOut, AnimationFormula.Cubic().easeInOut])
        data.append([AnimationFormula.Quartic().easeIn, AnimationFormula.Quartic().easeOut, AnimationFormula.Quartic().easeInOut])
        data.append([AnimationFormula.Quintic().easeIn, AnimationFormula.Quintic().easeOut, AnimationFormula.Quintic().easeInOut])
        data.append([AnimationFormula.Sine().easeIn, AnimationFormula.Sine().easeOut, AnimationFormula.Sine().easeInOut])
        data.append([AnimationFormula.Circular().easeIn, AnimationFormula.Circular().easeOut, AnimationFormula.Circular().easeInOut])
        data.append([AnimationFormula.Exponencial().easeIn, AnimationFormula.Exponencial().easeOut, AnimationFormula.Exponencial().easeInOut])
        data.append([AnimationFormula.Elastic().easeIn, AnimationFormula.Elastic().easeOut, AnimationFormula.Elastic().easeInOut])
        data.append([AnimationFormula.Bounce().easeIn, AnimationFormula.Bounce().easeOut, AnimationFormula.Bounce().easeInOut])
        data.append([AnimationFormula.Back().easeIn, AnimationFormula.Back().easeOut, AnimationFormula.Back().easeInOut])
        return data
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [tableView,
         animationView,
         clearButton,].forEach({view.addSubview($0);$0.translatesAutoresizingMaskIntoConstraints = false})
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: animationView.topAnchor, constant: -10).isActive = true
        
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        clearButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        clearButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        clearButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Quadratic", "Cubic", "Quartic", "Quintic", "Sine", "Circular", "Exponencial", "Elastic", "Bounce", "Back",][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath)
        cell.textLabel?.text = ["easeIn", "easeOut", "easeInOut",][indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animationView.createLines(animationFormula: data[indexPath.section][indexPath.item])
    }
    
    @objc func clearButtonTap() {
        animationView.clear()
    }
    
}


class AnimationView: UIView {
    
    var lineGroups: [[CGPoint]] = []
    
    var animator = PropertyAnimator()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        if lineGroups.isEmpty {
            context.clear(rect)
            return
        }
        
        context.setStrokeColor(UIColor.red.cgColor)
        
        for lineGroup in lineGroups {
            for (i, p) in lineGroup.enumerated() {
                if i == 0 {
                    context.move(to: CGPoint(x: 0.0, y: rect.maxY))
                } else {
                    context.addLine(to: p)
                }
            }
        }
        
        context.strokePath()
        
    }
    
    func clear() {
        if animator.isAnimating {
            return
        }
        lineGroups.removeAll()
        setNeedsDisplay()
    }
    
    func createLines(animationFormula: @escaping (CGFloat) -> CGFloat) {
        if animator.isAnimating {
            return
        }
        
        lineGroups.append([CGPoint]())
        
        animator.startAnimate(animationFormula: animationFormula) {  [weak self] (x, y) in
            guard let self = self else { return }
            guard var lastGroup = self.lineGroups.popLast() else { return }
            
            lastGroup.append(CGPoint(x: x * 200, y: 200 - y * 200))
            self.lineGroups.append(lastGroup)
            
            self.setNeedsDisplay()
        }
    }
    
}


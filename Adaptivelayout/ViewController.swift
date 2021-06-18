//
//  ViewController.swift
//  Adaptivelayout
//
//  Created by innertainment on 2021/06/18.
//

import UIKit

/*
 Storyboard를 이용할 때 사용법,
 - 각각의 constraint에 클래스를 적용한다.
 */

/*
 Programmatically, 사용법
 1. 각 view에 사용할 Constraint를 global 변수로 따로 뺀다. (Horizontal Orientation 때문에 그렇다)
     `
      // MARK: - Constraints
      // 따로 빼놓는 이유, screen orientation 할 때, resizing 해주어야 한다.
      var heightConstraint = NSLayoutConstraint()
      var widthConstraint  = NSLayoutConstraint()
      var topConstraint    = NSLayoutConstraint()
      var centerConstraint = NSLayoutConstraint()
     `
 2. 하나의 view에 필요한 property를 adaptive하게 정의해준다.
    `
     var buttonSize: CGSize {
         resized(size: CGSize(width: 200, height: 44), basedOn: .height)
     }
     
     var topSpace: CGFloat {
         adapted(dimensionSize: 30, to: .height)
     }
     
     var cornerRadius: CGFloat {
         adapted(dimensionSize: 8, to: dimension)
     }
    `
 3. viewDidLoad()에 사용할 view의 constraint를 설정해준다.
    `
     override func viewDidLoad() {
         super.viewDidLoad()
         setupViews()
         setupButtonConstraints()
     }
 
     func setupViews() {
         setupLearnMoreButton()
     }
        
     func setupLearnMoreButton() {
         button.setTitle("Learn more", for: .normal)
         button.backgroundColor = .systemPink
         button.layer.cornerRadius = cornerRadius
         button.translatesAutoresizingMaskIntoConstraints = false
         button.addTarget(self, action: #selector(openWikipedia), for: .touchUpInside)
         view.addSubview(button)
     }
 
     func setupButtonConstraints() {
         widthConstraint  = button.widthAnchor.constraint(equalToConstant: buttonSize.width)
         heightConstraint = button.heightAnchor.constraint(equalToConstant: buttonSize.height)
         topConstraint    = button.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpace)
         centerConstraint = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
         
         NSLayoutConstraint.activate([
             widthConstraint,
             heightConstraint,
             topConstraint,
             centerConstraint
         ])
     }
    `
 4. viewDidLayoutSubviews()에 font와 view constraint를 update하는 함수를 호출해준다.
    `
     override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
         setupFonts()
         updateConstraints()
     }
    
     func setupFonts() {
         button.titleLabel?.font = HelveticaNeue.regular(size: 16)
     }
 
     func updateConstraints() {
         updateButtonConstraints()
         view.updateAdaptedConstraints()
     }
 
     func updateButtonConstraints() {
         topConstraint.constant    = topSpace
         widthConstraint.constant  = buttonSize.width
         heightConstraint.constant = buttonSize.height
         button.layer.cornerRadius = cornerRadius
     }
    `
 */

class ViewController: UIViewController {
    
    // MARK: - Views
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupButtonConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupFonts()
        updateConstraints()
        print("Screen Orientation..")
    }
    
    // MARK: - Constraints
    // 따로 빼놓는 이유, screen orientation 할 때, resizing 해주어야 한다.
    var heightConstraint = NSLayoutConstraint()
    var widthConstraint  = NSLayoutConstraint()
    var topConstraint    = NSLayoutConstraint()
    var centerConstraint = NSLayoutConstraint()
}

// MARK: - Actions
private extension ViewController {
    @objc func openWikipedia() {
        let link = "https://en.wikipedia.org/wiki/Black_Square_(painting)"
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Setup views
private extension ViewController {
    func setupViews() {
        setupLearnMoreButton()
    }
    
    func setupFonts() {
        button.titleLabel?.font = HelveticaNeue.regular(size: 16)
    }
    
    func setupLearnMoreButton() {
        button.setTitle("Learn more", for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openWikipedia), for: .touchUpInside)
        view.addSubview(button)
    }
}

// MARK: - Setup constraints
private extension ViewController {
    func updateConstraints() {
        updateButtonConstraints()
        view.updateAdaptedConstraints()
    }
    
    var buttonSize: CGSize {
        resized(size: CGSize(width: 200, height: 44), basedOn: .height)
    }
    
    var topSpace: CGFloat {
        adapted(dimensionSize: 30, to: .height)
    }
    
    var cornerRadius: CGFloat {
        adapted(dimensionSize: 8, to: dimension)
    }
    
    func setupButtonConstraints() {
        widthConstraint  = button.widthAnchor.constraint(equalToConstant: buttonSize.width)
        heightConstraint = button.heightAnchor.constraint(equalToConstant: buttonSize.height)
        topConstraint    = button.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpace)
        centerConstraint = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        NSLayoutConstraint.activate([
            widthConstraint,
            heightConstraint,
            topConstraint,
            centerConstraint
        ])
    }
    
    func updateButtonConstraints() {
        topConstraint.constant    = topSpace
        widthConstraint.constant  = buttonSize.width
        heightConstraint.constant = buttonSize.height
        button.layer.cornerRadius = cornerRadius
    }
}

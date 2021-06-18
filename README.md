# Swift_AdaptiveLayout_Storyboard_OR_Programmatically

### Why use this?

- Adaptive layout across all screens
- Storyboard supported
- Without Storyboard
- Screen Orientation (Horizontal & Vertical) Supported

# Helper

```swift
//
//  Helper.swift
//  Adaptivelayout
//
//  Created by innertainment on 2021/06/18.
//

import UIKit

var dimension: Dimension {
    UIDevice.current.orientation.isPortrait ? .width : .height
}

//Input, design CGFloat
//Output, new CGFloat adpated to BaseScreenSize Ratio
func adapted(dimensionSize: CGFloat, to dimension: Dimension) -> CGFloat {
    
    //In order to get the current device screen dimensions, we have to call UIScreen.main.bounds.size
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var ratio: CGFloat = 0.0
    var resultDiemsnionSize: CGFloat = 0.0
    switch dimension {
    case .width:
        //To adapt CGFloat in base dimension (design dimension) passed to the function, first we need to calculate the ratio of base dimension size to base screen size.
        ratio = dimensionSize / Device.baseScreenSize.rawValue.width
        // Then we have to multiply the current width or height by the ratio to get the adapted CGFloat for the current screen size:
        resultDiemsnionSize = screenWidth * ratio
    case .height:
        ratio = dimensionSize / Device.baseScreenSize.rawValue.height
        resultDiemsnionSize = screenHeight * ratio
    }
    return resultDiemsnionSize
}

//The main purpose of the resized function is to resize passed CGSize preserveing the initial apsect ratio.
//We can choose which dimensino will be taken into account when rezing the base CGSize: Width or Height
func resized(size: CGSize, basedOn dimension: Dimension) -> CGSize {
    //In order to get the current device screen dimensions, we have to call UIScreen.main.bounds.size
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var ratio: CGFloat = 0.0
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    switch dimension {
    case .width:
        ratio = size.height / size.width
        width = screenWidth * (size.width / Device.baseScreenSize.rawValue.width)
        height = width * ratio
    case .height:
        ratio = size.width / size.height
        height = screenHeight * (size.height / Device.baseScreenSize.rawValue.height)
        width = height * ratio
    }
    
    return CGSize(width: width, height: height)
}
```

# Enum

```swift
//
//  Enum.swift
//  Adaptivelayout
//
//  Created by innertainment on 2021/06/18.
//

import UIKit

enum Dimension {
    case width
    case height
}

enum Device: RawRepresentable {
    
    static let baseScreenSize: Device = .iPhoneSE
    
    typealias RawValue = CGSize
    
    init?(rawValue: CGSize) {
        switch rawValue {
        case CGSize(width: 320, height: 568):
            self = .iPhoneSE
        case CGSize(width: 375, height: 667):
            self = .iPhone8
        case CGSize(width: 414, height: 736):
            self = .iPhone8Plus
        case CGSize(width: 375, height: 812):
            self = .iPhone11Pro
        case CGSize(width: 414, height: 896):
            self = .iPhone11ProMax
        default:
            return nil
        }
    }
    
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhone11Pro
    case iPhone11ProMax
    
    var rawValue: CGSize {
        switch self {
        case .iPhoneSE:
            return CGSize(width: 320, height: 568)
        case .iPhone8:
            return CGSize(width: 375, height: 667)
        case .iPhone8Plus:
            return CGSize(width: 414, height: 736)
        case .iPhone11Pro:
            return CGSize(width: 375, height: 812)
        case .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
        }
    }
    
}
```

# AdaptiveConstraint

```swift
//
//  AdaptiveConstraint.swift
//  Adaptivelayout
//
//  Created by innertainment on 2021/06/18.
//

import UIKit

class AdaptedConstraint: NSLayoutConstraint {
    
    // MARK: - Properties
    var initialConstant: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saveConstant()
        adaptConstant()
    }
    
}

// MARK: - Adapt constant
extension AdaptedConstraint {
    func adaptConstant() {
        if let dimension = getDimension(from: firstAttribute) {
            self.constant = adapted(dimensionSize: self.constant, to: dimension)
        }
    }
    
    func getDimension(from attribute: NSLayoutConstraint.Attribute) -> Dimension? {
        switch attribute {
        case .left, .right, .leading, .trailing, .width, .centerX, .leftMargin,
             .rightMargin, .leadingMargin, .trailingMargin, .centerXWithinMargins:
            return .width
        case .top, .bottom, .height, .centerY, .lastBaseline, .firstBaseline,
             .topMargin, .bottomMargin, .centerYWithinMargins:
            return .height
        case .notAnAttribute:
            return nil
        @unknown default:
            return nil
        }
    }
}

// MARK: - Reset constant
extension AdaptedConstraint {
    func saveConstant() {
        initialConstant = self.constant
    }
    
    func resetConstant() {
        if let initialConstant = initialConstant {
            self.constant = initialConstant
        }
    }
}
```

# Font

```swift
//
//  Font.swift
//  Adaptivelayout
//
//  Created by innertainment on 2021/06/18.
//

import UIKit

//MARK: - Font

extension CGFloat {
    var adaptedFontSize: CGFloat {
        adapted(dimensionSize: self, to: dimension)
    }
}

enum HelveticaNeue {
    static func regular(size: CGFloat) -> UIFont {
        UIFont(name: "HelveticaNeue", size: size.adaptedFontSize)!
    }
    
    static func bold(size: CGFloat) -> UIFont {
        UIFont(name: "HelveticaNeue-Bold", size: size.adaptedFontSize)!
    }
    /*
     Usage: titleLabel.font = HelveticaNeue.bold(size: 20)
     */
}
```

# UIView Extension for Screen Orientation

```swift
//
//  UIView+ScreenOrientation.swift
//  Adaptivelayout
//
//  Created by innertainment on 2021/06/18.
//

import UIKit

extension UIView {
    func updateAdaptedConstraints() {
        let adaptedConstraints = constraints.filter { (constraint) -> Bool in
            return constraint is AdaptedConstraint
        } as! [AdaptedConstraint]
        
        for constraint in adaptedConstraints {
            constraint.resetConstant()
            constraint.awakeFromNib()
        }
    }
}
```

# How to use

### 1. 각 view에 사용할 Constraint를 global 변수로 따로 뺀다. (Horizontal Orientation 때문에 그렇다)

```swift
// MARK: - Constraints
// 따로 빼놓는 이유, screen orientation 할 때, resizing 해주어야 한다.
var heightConstraint = NSLayoutConstraint()
var widthConstraint  = NSLayoutConstraint()
var topConstraint    = NSLayoutConstraint()
var centerConstraint = NSLayoutConstraint()
```

### 2. 하나의 view에 필요한 property를 adaptive하게 정의해준다.

```swift
var buttonSize: CGSize {
         resized(size: CGSize(width: 200, height: 44), basedOn: .height)
     }
   
 var topSpace: CGFloat {
     adapted(dimensionSize: 30, to: .height)
 }
 
 var cornerRadius: CGFloat {
     adapted(dimensionSize: 8, to: dimension)
 }
```

### 3. viewDidLoad()에 사용할 view의 constraint를 설정해준다.

```swift
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
```

### 4. viewDidLayoutSubviews()에 font와 view constraint를 update하는 함수를 호출해준다.

```swift
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
```

### Entire Code

```swift
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
```
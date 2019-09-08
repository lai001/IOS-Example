//
//  AnimationFormula.swift
//  EaseFunctions
//
//  Created by lai001 on 2019/9/8.
//  Copyright © 2019 none. All rights reserved.
//

/// Refer: https://github.com/manuelCarlos/Easing
/// https://easings.net/en
import UIKit

protocol Ease {
    func easeIn(_ x: CGFloat) -> CGFloat
    
    func easeOut(_ x: CGFloat) -> CGFloat
    
    func easeInOut(_ x: CGFloat) -> CGFloat
}

class AnimationFormula {
    
    struct Quadratic: Ease {
        func easeIn(_ x: CGFloat) -> CGFloat {
            return x * x
        }
        
        func easeOut(_ x: CGFloat) -> CGFloat {
            return -pow((x - 1.0), 2.0) + 1.0
        }
        
        func easeInOut(_ x: CGFloat) -> CGFloat {
            if x < 1 / 2 {
                return 2 * pow(x, 2)
            } else {
                return (-2 * pow(x, 2)) + (4 * x) - 1
            }
        }
    }
    
    struct Cubic: Ease {
        func easeIn(_ x: CGFloat) -> CGFloat {
            return pow(x, 3)
        }
        
        func easeOut(_ x: CGFloat) -> CGFloat {
            return pow(x - 1, 3) + 1
        }
        
        func easeInOut(_ x: CGFloat) -> CGFloat {
            if x < 1 / 2 {
                return 4 * pow(x, 3)
            } else {
                return 1 / 2 * pow(2 * x - 2, 3) + 1
            }
        }
    }
    
    struct Quartic: Ease {
        func easeIn(_ x: CGFloat) -> CGFloat {
            return pow(x, 4)
        }
        
        func easeOut(_ x: CGFloat) -> CGFloat {
            return pow(x - 1, 3) * (1 - x) + 1
        }
        
        func easeInOut(_ x: CGFloat) -> CGFloat {
            if x < 1 / 2 {
                return 8 * pow(x, 4)
            } else {
                return -8 * pow(x - 1, 4) + 1
            }
        }
    }
    
    struct Quintic: Ease {
        func easeIn(_ x: CGFloat) -> CGFloat {
            return pow(x, 5)
        }
        
        func easeOut(_ x: CGFloat) -> CGFloat {
            return pow(x - 1, 5) + 1
        }
        
        func easeInOut(_ x: CGFloat) -> CGFloat {
            if x < 1 / 2 {
                return 16 * pow(x, 5)
            } else {
                return 1 / 2 * pow(2 * x - 2, 5) + 1
            }
        }
    }
    
    struct Sine: Ease {
        func easeIn(_ x: CGFloat) -> CGFloat {
            return sin((x - 1) * .pi / 2) + 1
        }
        
        func easeOut(_ x: CGFloat) -> CGFloat {
            return sin(x * .pi / 2)
        }
        
        func easeInOut(_ x: CGFloat) -> CGFloat {
            return 1 / 2 * (1 - cos(x * .pi))
        }
    }
    
    struct Circular: Ease {
        func easeIn(_ x: CGFloat) -> CGFloat {
            return 1 - sqrt(1 - pow(x, 2))
        }
        
        func easeOut(_ x: CGFloat) -> CGFloat {
            return sqrt((2 - x) * x)
        }
        
        func easeInOut(_ x: CGFloat) -> CGFloat {
            if x < 1 / 2 {
                let h = 1 - sqrt(1 - 4 * x * x)
                return 1 / 2 * h
            } else {
                let f = 2 * x - 1
                let g = -(2 * x - 3) * f
                let h = sqrt(g)
                return 1 / 2 * (h + 1)
            }
        }
    }
    
    struct Exponencial: Ease {
        func easeIn(_ x: CGFloat) -> CGFloat {
            return x == 0 ? x : pow(2, 10 * (x - 1))
        }
        
        func easeOut(_ x: CGFloat) -> CGFloat {
            return x == 1 ? x : 1 - pow(2, -10 * x)
        }
        
        func easeInOut(_ x: CGFloat) -> CGFloat {
            if x == 0 || x == 1 {
                return x
            }
            
            if x < 1 / 2 {
                return 1 / 2 * pow(2, 20 * x - 10)
            } else {
                return -1 / 2 * pow(2, -20 * x + 10) + 1
            }
        }
    }
    
    struct Elastic: Ease {
        func easeIn(_ x: CGFloat) -> CGFloat {
            return sin(13 * .pi / 2 * x) * pow(2, 10 * (x - 1))
        }
        
        func easeOut(_ x: CGFloat) -> CGFloat {
            return sin(-13 * .pi / 2 * (x + 1)) * pow(2, -10 * x) + 1
        }
        
        func easeInOut(_ x: CGFloat) -> CGFloat {
            if x < 1 / 2 {
                return 1 / 2 * sin((13 * .pi / 2) * 2 * x) * pow(2, 10 * ((2 * x) - 1))
            } else {
                return 1 / 2 * (sin(-13 * .pi / 2 * ((2 * x - 1) + 1)) * pow(2, -10 * (2 * x - 1)) + 2)
            }
        }
    }
    
    struct Bounce: Ease {
        func easeIn(_ x: CGFloat) -> CGFloat {
            return 1 - easeOut(1 - x)
        }
        
        func easeOut(_ x: CGFloat) -> CGFloat {
            if x < 4 / 11 {
                return (121 * x * x) / 16
            } else if x < 8 / 11 {
                let f = (363 / 40) * x * x
                let g = (99 / 10) * x
                return f - g + (17 / 5)
            } else if x < 9 / 10 {
                let f = (4356 / 361) * x * x
                let g = (35442 / 1805) * x
                return  f - g + 16061 / 1805
            } else {
                let f = (54 / 5) * x * x
                return f - ((513 / 25) * x) + 268 / 25
            }
        }
        
        func easeInOut(_ x: CGFloat) -> CGFloat {
            if x < 1 / 2 {
                return 1 / 2 * easeIn(2 * x)
            } else {
                let f = easeOut(x * 2 - 1) + 1
                return 1 / 2 * f
            }
        }
    }
    
    struct Back: Ease {
        func easeIn(_ x: CGFloat) -> CGFloat {
            return x * x * x - x * sin(x * .pi)
        }
        
        func easeOut(_ x: CGFloat) -> CGFloat {
            return 1 - ( pow(1 - x, 3) - (1 - x) * sin((1 - x) * .pi))
        }
        
        func easeInOut(_ x: CGFloat) -> CGFloat {
            if x < 1 / 2 {
                let g = pow(2 * x, 3) - 2 * x * sin(2 * x * .pi)
                return 1 / 2 * g
            } else {
                let divide = pow(1 - (2 * x - 1), 3) - (1 - (2 * x - 1)) * sin((1 - (2 * x - 1)) * .pi)
                return 1 / 2 * (1 - divide) + 1 / 2
            }
        }
    }
    
}

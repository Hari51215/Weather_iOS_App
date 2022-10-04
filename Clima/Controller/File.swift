import UIKit
import Foundation

func funcCall (n1: Int, n2: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(n1, n2)
}

let ans = funcCall(n1: 2, n2: 3, operation: {(no1, no2) -> Int in return no1*no2 })
print(ans)

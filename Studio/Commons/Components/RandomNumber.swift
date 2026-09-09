import CoreGraphics
import Foundation

public protocol RandomNumberGeneratable: Sendable {
    func random(in range: ClosedRange<CGFloat>) -> CGFloat
}

public struct SystemRandomGenerator: RandomNumberGeneratable {
    public init() {}
    public func random(in range: ClosedRange<CGFloat>) -> CGFloat {
        return CGFloat.random(in: range)
    }
}

public struct ConstantRandomGenerator: RandomNumberGeneratable {
    private let fixedValue: CGFloat

    public init(fixedValue: CGFloat) {
        self.fixedValue = fixedValue
    }

    public func random(in range: ClosedRange<CGFloat>) -> CGFloat {
        return fixedValue
    }
}

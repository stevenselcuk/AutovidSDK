import XCTest

public extension XCUIElement {
    func humanTap() {
        XCTContext.runActivity(named: "Cinematic Tap: \(self.description)") { _ in
            guard self.waitForExistence(timeout: 5) else {
                print("⚠️ Warning: Element to tap not found, skipping step.")
                return
            }
            
            if !self.isHittable {
                XCUIApplication().slowSwipeUp(duration: 1.0)
            }
            
            Thread.sleep(forTimeInterval: 0.6)
            self.tap()
            Thread.sleep(forTimeInterval: 1.0)
        }
    }
    
    func humanType(_ text: String, speed: TimeInterval = 0.12) {
        XCTContext.runActivity(named: "Cinematic Typing: \(text)") { _ in
            self.humanTap()
            
            for char in text {
                self.typeText(String(char))
                Thread.sleep(forTimeInterval: speed)
            }
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
    
    func cinematicDrag(to dest: XCUIElement, duration: TimeInterval = 1.0, velocity: XCUIGestureVelocity = .default) {
        XCTContext.runActivity(named: "Cinematic Drag: \(self) -> \(dest)") { _ in
             let start = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
             let end = dest.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
             
             start.press(forDuration: 0.2, thenDragTo: end, withVelocity: velocity, thenHoldForDuration: 0.2)
             Thread.sleep(forTimeInterval: 0.5)
        }
    }

    func preciseSliderAdjustment(toNormalizedValue value: CGFloat, duration: TimeInterval = 1.0) {
         XCTContext.runActivity(named: "Cinematic Slider Adjust: \(value)") { _ in
             self.adjust(toNormalizedSliderPosition: value)
             Thread.sleep(forTimeInterval: duration)
         }
    }
    
    func longPressAndHold(duration: TimeInterval = 1.0) {
        XCTContext.runActivity(named: "Cinematic Long Press") { _ in
            self.press(forDuration: duration)
            Thread.sleep(forTimeInterval: 1.0)
        }
    }
    
    func simulateOrientationChange(to orientation: UIDeviceOrientation) {
          XCUIDevice.shared.orientation = orientation
          Thread.sleep(forTimeInterval: 1.0)
    }
    
    func slowSwipeUp(duration: TimeInterval = 2.0) { scroll(direction: .up, duration: duration) }
    func slowSwipeDown(duration: TimeInterval = 2.0) { scroll(direction: .down, duration: duration) }
    func slowSwipeLeft(duration: TimeInterval = 2.0) { scroll(direction: .left, duration: duration) }
    func slowSwipeRight(duration: TimeInterval = 2.0) { scroll(direction: .right, duration: duration) }

    private enum ScrollDirection { case up, down, left, right }
    
    private func scroll(direction: ScrollDirection, duration: TimeInterval) {
        XCTContext.runActivity(named: "Smooth Scrolling: \(direction)") { _ in

            let targetElement = self.findScrollable()
            
            guard targetElement.exists else {
                print("⚠️ Warning: No scrollable area (Table/Collection/Scroll) found.")
                return
            }

            let start: XCUICoordinate
            let end: XCUICoordinate
            
            switch direction {
            case .up:
                start = targetElement.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
                end = targetElement.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
            case .down:
                start = targetElement.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
                end = targetElement.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
            case .left:
                start = targetElement.coordinate(withNormalizedOffset: CGVector(dx: 0.8, dy: 0.5))
                end = targetElement.coordinate(withNormalizedOffset: CGVector(dx: 0.2, dy: 0.5))
            case .right:
                start = targetElement.coordinate(withNormalizedOffset: CGVector(dx: 0.2, dy: 0.5))
                end = targetElement.coordinate(withNormalizedOffset: CGVector(dx: 0.8, dy: 0.5))
            }
            
            start.press(forDuration: 0.1, thenDragTo: end, withVelocity: .slow, thenHoldForDuration: 0.1)
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
    
    private func findScrollable() -> XCUIElement {
        if self.elementType == .table || self.elementType == .collectionView || self.elementType == .scrollView {
            return self
        }
        
        let table = self.tables.firstMatch
        if table.exists { return table }
        
        let collection = self.collectionViews.firstMatch
        if collection.exists { return collection }
        
        let scroll = self.scrollViews.firstMatch
        if scroll.exists { return scroll }
        
        return self
    }
}


@MainActor
public class AutoVidDirector {
    public static func startProduction(app: XCUIApplication) {
        app.launch()
        print("🎬 On Air")
        Thread.sleep(forTimeInterval: 3.0)
    }
    
    public static func scene(_ name: String, action: () -> Void) {
        XCTContext.runActivity(named: "📽 Scene: \(name)") { _ in
            print("🎬 Scene: \(name)")
            action()
            Thread.sleep(forTimeInterval: 1.5)
        }
    }
    
    public static func waitToRead(seconds: TimeInterval = 2.0) {
        Thread.sleep(forTimeInterval: seconds)
    }
    
    public static func wrapProduction() {
        Thread.sleep(forTimeInterval: 3.0)
        print("✅ Recording Complete. Ready for Editing!")
    }
    
    public static func announce(_ text: String) {
        XCTContext.runActivity(named: "📢 Director Announce: \(text)") { _ in
            print("📢 \(text)")
            // Future: Inject UI overlay if possible
            Thread.sleep(forTimeInterval: 1.0)
        }
    }
}
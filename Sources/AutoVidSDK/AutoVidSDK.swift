import XCTest
import Foundation

@MainActor
public struct AutovidConfig {
    public static var outputBaseURL: URL = {
        #if targetEnvironment(simulator)
        return URL(fileURLWithPath: "/tmp/\(outputDirectoryName)", isDirectory: true)
        #else
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(outputDirectoryName)
        #endif
    }()
    
    public static var outputDirectoryName = "Autovid_Productions"
}

public extension XCUIElement {
    
    func humanTap() {
        XCTContext.runActivity(named: "Cinematic Tap: \(self.description)") { _ in
            guard self.waitForExistence(timeout: 5) else {
                print("⚠️ Warning: Element to tap not found, skipping step.")
                return
            }
            
            if !self.isHittable {
                let app = XCUIApplication()
                app.slowSwipeUp(duration: 1.0)
            }
            
            AutoVidDirector.wait(0.6)
            self.tap()
            AutoVidDirector.wait(1.0)
        }
    }
    
    func humanType(_ text: String, speed: TimeInterval = 0.12) {
        XCTContext.runActivity(named: "Cinematic Typing: \(text)") { _ in
            self.humanTap()
            for char in text {
                self.typeText(String(char))
                AutoVidDirector.wait(speed)
            }
            AutoVidDirector.wait(0.5)
        }
    }
    
    func cinematicDrag(to dest: XCUIElement, duration: TimeInterval = 1.0, velocity: XCUIGestureVelocity = .default) {
        XCTContext.runActivity(named: "Cinematic Drag: \(self) -> \(dest)") { _ in
             let start = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
             let end = dest.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
             start.press(forDuration: 0.2, thenDragTo: end, withVelocity: velocity, thenHoldForDuration: 0.2)
             AutoVidDirector.wait(0.5)
        }
    }

    func preciseSliderAdjustment(toNormalizedValue value: CGFloat, duration: TimeInterval = 1.0) {
         XCTContext.runActivity(named: "Cinematic Slider Adjust: \(value)") { _ in
             self.adjust(toNormalizedSliderPosition: value)
             AutoVidDirector.wait(duration)
         }
    }
    
    func longPressAndHold(duration: TimeInterval = 1.0) {
        XCTContext.runActivity(named: "Cinematic Long Press") { _ in
            self.press(forDuration: duration)
            AutoVidDirector.wait(1.0)
        }
    }
    
    func simulateOrientationChange(to orientation: UIDeviceOrientation) {
          XCUIDevice.shared.orientation = orientation
          AutoVidDirector.wait(1.5)
    }
    
    func slowSwipeUp(duration: TimeInterval = 2.0) { scroll(direction: .up, duration: duration) }
    func slowSwipeDown(duration: TimeInterval = 2.0) { scroll(direction: .down, duration: duration) }
    func slowSwipeLeft(duration: TimeInterval = 2.0) { scroll(direction: .left, duration: duration) }
    func slowSwipeRight(duration: TimeInterval = 2.0) { scroll(direction: .right, duration: duration) }

    private enum ScrollDirection { case up, down, left, right }
    
    private func scroll(direction: ScrollDirection, duration: TimeInterval) {
        XCTContext.runActivity(named: "Smooth Scrolling: \(direction)") { _ in
            let targetElement = self.findScrollable()
            
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
            AutoVidDirector.wait(0.5)
        }
    }
    
    private func findScrollable() -> XCUIElement {
        let scrollableTypes: [XCUIElement.ElementType] = [.table, .collectionView, .scrollView]
        if scrollableTypes.contains(self.elementType) { return self }
        
        let found = self.descendants(matching: .any).element(matching: NSPredicate(format: "elementType IN %@", scrollableTypes.map { $0.rawValue }))
        return found.exists ? found.firstMatch : XCUIApplication()
    }

    func takeSnapshot(name: String) {
        AutoVidDirector.capture(name: name, element: self)
    }
}

@MainActor
public class AutoVidDirector {
    private static var sessionID = ""
    private static var storageURL: URL?
    private static var shotCounter = 0

    internal static func wait(_ duration: TimeInterval) {
        let expectation = XCTestExpectation(description: "Cinematic Wait")
        _ = XCTWaiter.wait(for: [expectation], timeout: duration)
    }

    public static func startProduction(app: XCUIApplication) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        sessionID = formatter.string(from: Date())
        shotCounter = 0
        
        setupStorage()
        app.launch()
        
        print("🎬 On Air")
        wait(3.0)
    }
    
    public static func scene(_ name: String, snapshotAfter: Bool = true, action: () -> Void) {
        XCTContext.runActivity(named: "📽 Scene: \(name)") { _ in
            print("🎬 Scene: \(name)")
            action()
            if snapshotAfter {
                self.capture(name: "Final_of_\(name.replacingOccurrences(of: " ", with: "_"))")
            }
            wait(1.5)
        }
    }
    
    public static func capture(name: String, element: XCUIElement? = nil) {
        XCTContext.runActivity(named: "📸 Screenshot: \(name)") { activity in
            wait(0.3)
            
            shotCounter += 1
            let prefix = String(format: "%03d", shotCounter)
            let safeName = name.replacingOccurrences(of: " ", with: "_")
            let finalName = "\(prefix)_\(safeName)"
            
            let screenshot = element?.screenshot() ?? XCUIScreen.main.screenshot()
            
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = finalName
            attachment.lifetime = .keepAlways
            activity.add(attachment)
            
            saveToDisk(screenshot: screenshot, fileName: finalName)
        }
    }

    private static func saveToDisk(screenshot: XCUIScreenshot, fileName: String) {
        guard let folder = storageURL else { return }
        let fileURL = folder.appendingPathComponent("\(fileName).png")
            
        autoreleasepool {
            do {
                if let data = screenshot.image.pngData() {
                    try data.write(to: fileURL, options: .atomic)
                    print("💾 Saved: \(fileName).png")
                }
            } catch {
                print("❌ Disk Error: \(error.localizedDescription)")
            }
        }
    }

    private static func setupStorage() {
        #if targetEnvironment(simulator)
        if let sharedDir = ProcessInfo.processInfo.environment["SIMULATOR_SHARED_RESOURCES_DIRECTORY"] {
            storageURL = URL(fileURLWithPath: sharedDir).appendingPathComponent("AutovidScreenShots").appendingPathComponent(sessionID)
        } else {
            storageURL = AutovidConfig.outputBaseURL.appendingPathComponent(sessionID)
        }
        #else
        storageURL = AutovidConfig.outputBaseURL.appendingPathComponent(sessionID)
        #endif
        
        if let url = storageURL {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            print("📁 Storage Path: \(url.path)")
        }
    }

    public static func waitToRead(seconds: TimeInterval = 2.0) {
        print("⏳ Reading time: \(seconds)s")
        wait(seconds)
    }
    
    public static func announce(_ text: String) {
        XCTContext.runActivity(named: "📢 Director Announce: \(text)") { _ in
            print("📢 \(text)")
            wait(1.0)
        }
    }
    
    public static func wrapProduction() {
        wait(3.0)
        print("✅ Recording Complete.")
        
        if let url = storageURL {
            #if targetEnvironment(simulator)
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/open")
            process.arguments = [url.path]
            try? process.run()
            #endif
        }
    }
}


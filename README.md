# AutoVidSDK

**AutoVidSDK** is a specialized Swift library designed to transform standard UI tests into "Cinematic" productions. It extends `XCTest` with human-like interactions, smooth animations, and directorial controls, making it perfect for generating high-quality App Store Previews, marketing videos, and demo clips directly from your UI tests.

## 🌟 Features

*   **Cinematic Interactions**: tap, type, drag, and scroll with human-like timing and smoothness.
*   **Director Mode**: Organize your test execution into "Scenes" for better pacing and log readability.
*   **Smooth Scrolling**: Custom `slowSwipe` methods to replace jerky standard swipes, creating a natural feel.
*   **Smart Waiting**: Built-in `waitToRead` methods to give viewers time to digest content on screen.
*   **Reliability**: built-in `waitForExistence` checks to reduce flakiness during recording sessions.

## 📦 Installation

### Swift Package Manager

Add `AutoVidSDK` to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/stevenselcuk/AutoVidSDK.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourAppUITests",
        dependencies: ["AutoVidSDK"]
    )
]
```

Or add it via Xcode:
1.  File > Add Packages...
2.  Enter the URL of this repository.
3.  Add it to your **UI Testing Bundle** target.

## 🚀 Getting Started

1.  **Import the SDK** in your UI Test file.
2.  **Use `AutoVidDirector`** to manage the flow.
3.  **Replace standard interactions** (e.g., `.tap()`) with cinematic ones (e.g., `.humanTap()`).

### Quick Example

```swift
import XCTest
import AutoVidSDK

final class AppStorePreviewTests: XCTestCase {
    
    @MainActor
    func testAppPreviewFlow() throws {
        let app = XCUIApplication()
        
        // 1. Start the Production (Launches app & prepares for recording)
        AutoVidDirector.startProduction(app: app)
        
        // 2. Define a Scene
        AutoVidDirector.scene("Onboarding Flow") {
            // Use human-like typing
            let nameField = app.textFields["NameInput"]
            nameField.humanTap()
            nameField.humanType("John Doe", speed: 0.15)
            
            // Use smooth button presses
            app.buttons["Continue"].humanTap()
        }
        
        // 3. Navigate with smooth scrolling
        AutoVidDirector.scene("Explore Feed") {
            // Swipes slowly to show content
            app.slowSwipeUp(duration: 2.0)
            
            // Pause to let the viewer read
            AutoVidDirector.waitToRead(seconds: 1.5)
        }
        
        // 4. Wrap up
        AutoVidDirector.wrapProduction()
    }
}
```

## 🎥 API Reference

### AutoVidDirector

The `AutoVidDirector` class acts as the coordinator for your recording session.

*   `startProduction(app: XCUIApplication)`: Launches the app and waits for the initial animation to settle.
*   `scene(_ name: String, action: () -> Void)`: Wraps a block of interactions logic into a named "Scene". Adds logs and pauses for pacing.
*   `waitToRead(seconds: TimeInterval)`: pauses execution explicitly to allow viewers to read text on the screen.
*   `wrapProduction()`: Finalizes the recording session with a closing delay to avoid abrupt cuts.
*   `announce(_ text: String)`: Logs a director's announcement (useful for debugging flow).

### XCUIElement Extensions (Cinematic Actions)

Standard `XCUIElement` methods are extended for smoother visual results.

#### Tapping & Typing
*   `humanTap()`: Waits for existence, ensures hit-ability (scrolls if needed), pauses briefly, and then taps.
*   `humanType(_ text: String, speed: TimeInterval = 0.12)`: Taps the element and types text character-by-character with a natural delay.
*   `longPressAndHold(duration: TimeInterval = 1.0)`: Performs a long press action.

#### Scrolling & Motion
*   `slowSwipeUp(duration: TimeInterval = 2.0)`: Smoothly scrolls up.
*   `slowSwipeDown(duration: TimeInterval = 2.0)`: Smoothly scrolls down.
*   `slowSwipeLeft(duration: TimeInterval = 2.0)`: Smoothly scrolls left.
*   `slowSwipeRight(duration: TimeInterval = 2.0)`: Smoothly scrolls right.
*   `cinematicDrag(to dest: XCUIElement, duration: TimeInterval = 1.0, velocity: XCUIGestureVelocity = .default)`: Drags an element to another element's position smoothly.

#### Controls
*   `preciseSliderAdjustment(toNormalizedValue value: CGFloat, duration: TimeInterval = 1.0)`: Adjusts a slider to a specific value over a set duration, avoiding "jumping".
*   `simulateOrientationChange(to orientation: UIDeviceOrientation)`: Rotates the device and waits for the UI to adapt.

## 💡 Tips for Great Recordings

1.  **Pacing is Key**: Use `waitToRead` liberally. Viewers need time to process what they see.
2.  **Break it Down**: Use `scene` blocks to logically separate parts of your flow. It makes the test code easier to read and maintain.
3.  **Hide the Status Bar**: For professional App Store previews, remember to clean up the status bar (full battery, 9:41 time) using `xcrun simctl status_bar` commands before running your test.
4.  **Use Accessibility Identifiers**: Ensure your UI elements have `.accessibilityIdentifier` set in your main app code for reliable finding.

## See Example

See the example mock app for more details.
https://github.com/stevenselcuk/AutoVidMockApp

## 📄 License

This SDK is available under the MIT license. See the LICENSE file for more info.

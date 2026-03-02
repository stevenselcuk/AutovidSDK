# AutoVidSDK

## 📽 What is this?

A Swift library that turns standard UI tests into high-quality App Store Previews and marketing videos. It extends `XCTest` to make interactions look human and animations look cinematic.

## ✨ What does it do?

- **Human Interactions:** Performs taps and typing with natural delays.
- **Smooth Scrolling:** Replaces jerky swipes with slow, fluid scrolling.
- **Director Mode:** Organizes tests into "Scenes" for better pacing and readability.
- **Smart Pauses:** Built-in "reading time" so viewers can actually digest what's on screen.

## 🚀 How to use it?

### 1. Start & Wrap

Initialize the production at the start and finalize it at the end to generate the report.

```swift
AutoVidDirector.startProduction(app: app)
// ... your actions ...
AutoVidDirector.wrapProduction()
```

### 2. Define Scenes

Break your flow into logical scenes for the video.

```swift
AutoVidDirector.scene("Onboarding") {
    app.textFields["Email"].humanType("hello@autovid.com")
    app.buttons["Next"].humanTap()
}
```

### 3. Cinematic Actions

Swap standard XCTest methods for cinematic ones:

- `.tap()` ➡️ `.humanTap()`
- `.typeText()` ➡️ `.humanType("Hello")`
- `.swipeUp()` ➡️ `.slowSwipeUp(duration: 2.0)`
- `AutoVidDirector.waitToRead(seconds: 2.0)` (Give viewers time to read)

## 📂 Where are my files?

Once the test finishes, all frames and screenshots are collected:

- **Simulator:** The output folder opens automatically in Finder.
- **Real Device:** Saved within the Xcode Test Report (Attachments).

## 📹 Need videos?

Please see [AutoVid](https://github.com/stevenselcuk/AutoVid) companion macoOS app.

## Example App

Please see [AutoVidMockApp](https://github.com/stevenselcuk/AutoVidMockApp) iOS app for example usage.

## 📦 Installation

Add via Swift Package Manager:
`https://github.com/stevenselcuk/AutoVidSDK.git`

AudioNote - Swift version
================
This is a simple iPhone app allows user to record audio and transcribes it to text. A location is captured for each note.

### Note: 
For Objective-C version, please looking at [here](https://github.com/toandk/challenge-iOSDev)

Main features:

- A user can to create a note by starting to record audio
- Notes will be created with the audio and transcribed using GG ASR/Voice-to-Text service 
- Users can be able to edit the transcribed text
- Users should be able to see a list of their notes
- A location automatically captured and saved metadata for the note
- Users can select a note and view the transcribed/edited text, playback the voice note, and view the location of where the voice note was originally taken.
- The user can attach a photo or multiple photo to a note
- Allow the user to share the audio + text + attached image(s) via iMessage and other services that support that media
- Map view of all the notes with a tap to select a note and view it
- Have an iMessage app that, when activated in iMessage, shows a list of taken notes and allows for sharing


App using map and places data of GoogleMaps [SDK for iOS](https://developers.google.com/maps/documentation/ios-sdk/)

Code using MVVM design patern, bases on [ReactiveCocoa] [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveCocoa) library for Swift

### Compatibility
iPhone app Support iOS 10.0+
iMessage app required iOS 10.0+

### Install & Run
Clone project: 

```
git clone git@github.com:toandk/challenge-iOSDev-Swift.git
```
Install Cocoapods libraries
```
pod install
```
Open `NoteSwift.xcworkspace` and Run (CMD + R)

### Crash report
Show on [fabric.io Crashlytics](https://fabric.io/tdktest/ios/apps/com.tdk.noteaudio/issues?time=last-seven-days&event_type=crash&subFilter=state&state=open)

### Deploy testing
- Install [fastlane](https://github.com/fastlane/fastlane)
- Setup fastlane config at {PROJECT_DIR}/fastlane
- cd to project folder and run this command:

```
fastlane beta
```
Currently testing only on Crashlytics group 'tdktesters'



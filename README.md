![The Big 3](https://github.com/jaywardell/The-Big-3/blob/adding_watch_widgets/App/Assets.xcassets/AppIcon.appiconset/icon.png?raw=true "icon")
# The Big 3

The Big 3 is a task list app for iOS that helps you focus on what’s most important.

Most task manager apps let you list every possible thing that you could want to do. Then, when it’s time to get things done, your list is so long that you can spend more time managing it than using it.

The Big 3 lets you focus on the 3 things that you need to do right now.  You plan out your Big 3 goals all at once.  Then you have to either complete each goal, or explicitly say that you’re not going to do it today.  You can’t start a new Big 3 until you’ve completed or postponed everything in your current Big 3.

The Big 3 includes a watch app so that you can track and complete your Big 3 on your watch. It also includes a range of widgets for both the home screen and lock screen.

You can import reminders from your Reminders app. When you mark them as completed in The Big 3, they’re also marked as completed in the Reminders app.


https://www.jaywardell.me/wp-content/uploads/2022/12/screenrecording.mov

## Architecture

The Big 3 is a native SwiftUI application with almost no use of UIKit. It uses an MVVM architecture.  Anywhere possible, code is shared across the three targets (iOS App, iOS Widgets and Watch App), and most code is written to be portable for that reason.  Conditional compiling helps with this in several places. 

The composition root for each target is a top-level model object. It acts as a container for all non-user-facing code, and updates the main object. These updates can then trigger view updates via `@ObservableObject`.

The majority of the model layer was written using test-driven development. Then the view and view model layer were written to support the interface created from the TDD.


### User Interface

There are three main views that are shown through the life cycle of the app. The first is for planning the big 3. The second is a classic todo list UI with a twist. The third is a simple summary. A top-level view determines which to show based on the state of the main model object. 

To enforce only 3 entries in the planning view, and not have the fields for the entries move around when things change, I couldn't use SwiftUI's `List`. So I wrote a custom layout view called `CountedRows`.

The main view, where the user can either complete or postpone a goal, presents a novel user interface.  Each button is just off screen.  The user can either tap or drag to bring the button onscreen, and then complete the action by tapping the button.  This design of course was inspired by the drag-to-expose delete buttons in iOS table views, but with a different spin.


### Model Layer

The core module of the model layer is a `Plan` object. It holds up to 3 goals. The `Planner` object contains a `Plan` and  maintains the state of the app.  The planner is shared between the iOS and watchOS apps to ensure that they are in synch.

Plans are saved to `UserDefaults` on both iOS and watchOS apps.  `WatchConnectivity` is used to keep them in synch. A separate class, `CompletionLog`, is used to record the date of any completed goals. 

I considered using a database solution for this, but the Planner takes up very little memory at all and is transient, while the log will probably only hold at most thousands of entries.  The log is loaded and saved asynchronously using async/await, so even if it does get very large, it shouldn’t block the user interface.

### View Model Layer

Each view that requires a view model defines its own `ViewModel` type.  Then a model object (usually the `Planner`), is extended to vend an instance of that type.  These extensions are stored in separate modules so that only the modules necessary for a given target need to be imported.


## UI Design

The majority of the views that the user sees on a regular basis are custom designs.  The goals were:

* provide a fun and unique interaction pattern while not straying too far from what users expect in iOS.
* make the user feel in control
* give the user the maximum amount of information possible at any given time
* ensure that destructive actions take multiple steps to complete to avoid accidental triggering
* make user actions intuitable and easily discoverable
* make an aesthetically pleasing app

Honestly, this was the funnest part of making this app, though it’s also the place where the code is sometimes most complex.

There are subtle animations throughout. The color scheme is meant to be serious and calming. A cool accent color and light typeface reenforce the idea that the app is meant to help the user take control of their goals.

## requirements:
The Big 3 runs on iOS 16 and watchOS 9.

#  todo

- [ ] add logo back above text fields when editing a task
- [ ] mac target with iCloud synching 
- [ ] history widget?


## for 1.0.1
- [x] duplicate entries in history view? at least on my XR on 1/31/23 for all days.
    It was a problem with CompletionLog.loadArchive(). 
    Its load flag was being set AFTER the archive had loaded,
    so if more than one thread tried to call loadArchive() at the same time, 
    the archive would load twice
    and the  entries for a given day would be duplicated.
    I fixed it by moving the setting of the flag to right after the checking of the flag

## to make UI more acceptable to App Store:
- [x] add done button to History
- [x] check boxes are shown by default
- [x] no ghost check in checkboxes
- [x] no BrandedHeader for button in Review View

- [ ] consider a mac port as a menu bar addition
- [x] done row on watch should have a rounded rectangle background instead of the full rectangle
- [x] test against iPad
- [x] try a circular widget
- [x] when a goal is completed in the watch app, it's added to the history on the phone app
- [x] watch app updates info on host app
- [x] watch app reports info from host app
- [x] widget
- [x] logging to a history
- [x] big 3 background
- [x] importing from reminders

## had problems:
- [ ] try watch widgets (may be synch issues...)
see notes in branch `adding_watch_widgets`

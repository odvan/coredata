# coredata

Swift 3.0, Xcode 8.xx

Note: after build you need to wait couple of minutes for writing data in CoreData to create a chart in "statistic" tab.

App to show basic skills with Core Data. Imagine some sensor like apple watch or kind of for measuring heart rate.
App is putting each minute new value in Core Data database. Depending upon heart rate the main window show different geometrical figures (NASA stuff for astrounats - they shouldn't worry because of numbers, but geometrical figures show changes in a non-dramatic way). Slider at the bottom imitate different pulse (beats per minute).
Second view is for database and some graphical representation for last 30 minutes readings.

In theory app should include background mode, but I can't make it since I don't have actual sensor could waking up ios device.

Technologies:
- working with Core Data (writing, fetching);
- seamlessly combining it with tableview;
- creating chart from Core Data fetch request;
- some skills creating bezier path and basic geometrical figures;
- segmented control for switching between viewcontrollers.

With different heart rate figures changes (in theory):

![coredatademo-00](https://user-images.githubusercontent.com/23110283/27285185-75d7412a-5504-11e7-9339-8388e00e4e29.gif)

![cd_01](https://cloud.githubusercontent.com/assets/23110283/22407194/e4cc736c-e672-11e6-80d6-c00f65f980c0.png)
![cd_02](https://cloud.githubusercontent.com/assets/23110283/22407196/e7965d1a-e672-11e6-92a6-eca750c4dc5f.png)

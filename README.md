# DailyNews
> Small iOS client showing news from [News API](https://newsapi.org/).


## General Info
A small and clean iOS app for reading live news sourced from News API. Using 100% programmatic UI and no external dependencies.

### Technologies used
* Xcode 12
* Swift 5.3
* iOS 13.6
* UIKit
* 100% programmatic UI (no storyboard)
* UITableView (both regular and diffable)
* Collapsible sections in table view
* Networking using URLSession
* JSON parsing using JSONDecoder
* Public API
* Async download of images

## Setup
To run this app you need to register an account at the News API service ([newsapi.org](https://newsapi.org)) and get an API key. Put this key in file called `Key.plist` and you should be all set. For your conveninence, a `Key-SAMPLE.plist` file has been included in the project.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>apiKey</key>
  <string>YOUR_API_KEY_HERE</string>
</dict>
</plist>
```

## Screenshots

| Headlines | Search | Article View |
| -------- | --------- | --------- |
| ![Headlines](./Screenshots/DailyNewsHeadlines.png) | ![Search](./Screenshots/DailyNewsSearch.png) | ![Article View](./Screenshots/DailyNewsArticleView.png) |

| Sources | Source View |
| -------- | --------- |
| ![Sources](./Screenshots/DailyNewsSources.png) | ![Source View](./Screenshots/DailyNewsSourceView.png) |

## Comments and ideas?
Issues and PR:s are encouraged and highly welcome.


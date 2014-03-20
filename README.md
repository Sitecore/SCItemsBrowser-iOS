# Items Browser Component for iOS

This library contains GUI controls for viewing the content tree or some its branches as a hierarchy. The user interface idioms are similar to those used in desktop file managers such as 

* Norton Commander
* Total Commander
* Far Manager

![1-List-Content-Tree](https://github.com/Sitecore/SCItemsBrowser-iOS/raw/master/Readme-images/1-ListMode.png)
![2-Instance-Content-Tree](https://github.com/Sitecore/SCItemsBrowser-iOS/raw/master/Readme-images/1-Instance-Home.png)


# Licence
```
SITECORE SHARED SOURCE LICENSE
```

# Distribution
The component is distributed as a **static framework** for iOS. 

```
Note : CocoaPods approach is not offcially supported. However, we'll happily accept your pull requests if you create one.
```


# Requirements

1. **iOS 6** and newer
2. **ARC** should be **enabled**
3. [Sitecore iOS SDK 2.0](https://github.com/sitecore/sitecore-ios-sdk/) and its dependencies.



# Cells Customization

The user is not limited to displaying item names in textual format as you might have thought looking at the screenshots above. Cells are fully customizable by the user and the user can display any content, retrieved from the item. Check out screenshots of the media folder below :

![3-List-Media-Tree](https://github.com/Sitecore/SCItemsBrowser-iOS/raw/master/Readme-images/2-ListMedia.png)
![4-Grid-Content-Tree](https://github.com/Sitecore/SCItemsBrowser-iOS/raw/master/Readme-images/3-Grid-Media.png)
![5-Instance-Media-Tree](https://github.com/Sitecore/SCItemsBrowser-iOS/raw/master/Readme-images/2-InstanceMedia.png)


# Content Views and Subclassing

The library follows the CocoaTouch conventions and best practices.
It offers two kinds of components :

* [SCItemListBrowser](http://sitecore.github.io/SCItemsBrowser-iOS/Classes/SCItemListBrowser.html)
* [SCItemGridBrowser](http://sitecore.github.io/SCItemsBrowser-iOS/Classes/SCItemGridBrowser.html)

They are based on UITableView and UICollectionView respectively. However, you can implement your own content viewer based on any built-in or third-party iOS controls. In this case you should subclass the 
[SCAbstractItemsBrowser](http://sitecore.github.io/SCItemsBrowser-iOS/Classes/SCAbstractItemsBrowser.html) controller and provide the missing code to interact with your content UI and provide data for it.

# Documentation
You can find the library's **appledoc reference** at our [github pages](http://sitecore.github.io/SCItemsBrowser-iOS/v1.0-sdk2.0/hierarchy.html)
Full documentation is available at **SDN**.

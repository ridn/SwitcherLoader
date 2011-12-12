SwitcherLoader
========
![SwitcherLoader Example](http://f.cl.ly/items/3s3T3K1m3h373f0b2s1i/IMG_0602.PNG "Screenshot")

Load custom UIViews into the AppSwitcher

NSBundles
--------
* SwitcherLoader loads your view from a bundle from /Library/SwitcherLoader/Plugins
* Must be a valid NSBundle
* The NSPricipalClass must be a subclass of a UIView
* The bundle identifier must be set
* Custom names and icons can be loaded by setting the name key and the icon key, icon must be in bundle
* SwitcherLoader does check the MinimumOSVersion key in the bundle's plist, if you want any system version leave it blank

UIView
--------
* SwitcherLoader calls upon the initWithFrame: method, giving the view the frame of of the AppSwitchers height and width
* Currently there is no support for viewDidAppear and viewDidDisappear methods

________
* You can easily start a plugin by using this theos nic template: [https://github.com/Fr0zenSun/SwitcherLoader/blob/master/SwitcherLoader_plugin.nic](https://github.com/Fr0zenSun/SwitcherLoader/blob/master/SwitcherLoader_plugin.nic "github/")
* [Follow me on twitter](http://twitter.com/fr0zensun"Twitter")
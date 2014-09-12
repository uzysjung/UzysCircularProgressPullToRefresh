UzysCircularProgressPullToRefresh
=================================

Give Pinterest Like PullToRefresh to any UIScrollView with just simple code

![Screenshot](https://raw.github.com/uzysjung/UzysCircularProgressPullToRefresh/master/UzysCircularProgressPulltoRefresh2.gif)
<!---![Screenshot](https://raw.github.com/uzysjung/UzysCircularProgressPullToRefresh/master/UzysCircularProgressPullToRefresh.gif)--->

**UzysCircularProgressPullToRefresh features:**

* It's very simple to use.
* Support iOS7.
* Support only ARC
* Support CocoaPods.
* Support Orientation change.

## Installation
Copy over the files libary folder to your project folder

## Usage
###Import header.

``` objective-c
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
```

### Initialize
adding PullToRefreshActionHandler

``` objective-c
-(void)viewWillAppear:(BOOL)animated
{
  __weak typeof(self) weakSelf =self;
  [_tableView addPullToRefreshActionHandler:^{
      [weakSelf insertRowAtTop];
  }];
}
```
### programmatically trigger PullToRefresh
``` objective-c
[_tableView triggerPullToRefresh];
```

### stop PullToRefresh Activity Animation
``` objective-c
[_tableView stopRefreshAnimation];
```

### support customization 
#### size change
``` objective-c
[self.tableView.pullToRefreshView setSize:CGSizeMake(40, 40)];
```
#### borderWidth change
``` objective-c
[self.tableView.pullToRefreshView setBorderWidth:4];
```
#### borderColor change
``` objective-c
[self.tableView.pullToRefreshView setBorderColor:[UIColor colorWithRed:75/255.0 green:131/255.0 blue:188/255.0 alpha:1.0]];
```
#### Image Icon change
``` objective-c
[self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"thunderbird"]];
```

#### pulling offset change
``` objective-c
[self.tableView.pullToRefreshView setProgressThreshold:25];
```

#### set LandScape Inset , Portrait Inset at Each Orientation.
``` objective-c
[self.tableView addTopInsetInPortrait:64 TopInsetInLandscape:52]; 
// iOS 7 LandScape Navigationbar size 52 , Portrait Navigationbar size 64  
```
must call these customization methods after calling 'addPullToRefreshActionHandler'

## Contact
 - [Uzys.net](http://uzys.net)

## License
 - See [LICENSE](https://github.com/uzysjung/UzysCircularProgressPullToRefresh/blob/master/LICENSE).

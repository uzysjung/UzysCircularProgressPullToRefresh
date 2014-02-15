UzysCircularProgressPullToRefresh
=================================

Give Pinterest Like PullToRefresh to any UIScrollView with just simple code

![Screenshot](https://raw.github.com/uzysjung/UzysCircularProgressPullToRefresh/master/UzysCircularProgressPulltoRefresh2.gif)
<!---![Screenshot](https://raw.github.com/uzysjung/UzysCircularProgressPullToRefresh/master/UzysCircularProgressPullToRefresh.gif)--->

**UzysSlideMenu features:**

* It's very simple to use.
* Support iOS7.
* Support only ARC
* Support CocoaPods. (to be)

## Installation
Copy over the files libary folder to your project folder

## Usage
###Import header.

``` objective-c
#import "UIScrollView+UZYSCircularProgressPullToRefresh.h"
```

### Initialize
adding PullToRefreshActionHandler

``` objective-c
-(void)viewWillAppear:(BOOL)animated
{
  __weak typeof(self) weakSelf = self;
  [_tableView addPullToRefreshActionHandler:^
  {
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
[self.tableView.pullToRefreshView setSize:CGSizeMake(40.0, 40.0)];
```
#### borderWidth change
``` objective-c
[self.tableView.pullToRefreshView setBorderWidth:4.0];
```
#### borderColor change
``` objective-c
[self.tableView.pullToRefreshView setBorderColor:[UIColor colorWithRed:75.0 / 255.0 green:131.0 / 255.0 blue:188.0 / 255.0 alpha:1.0]];
```
#### Image Icon change
``` objective-c
[self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"thunderbird"]];
```

#### pulling offset change (UZYSRadialProgressActivityIndicator.m)
``` objective-c
#define PullToRefreshThreshold 80.0
```

### Removal
You have to remove when your scroll view is about to get deallocated
``` objective-c
[self.tableView removePullToRefreshView];
```

## Contact
 - [Uzys.net](http://uzys.net)

## License
 - See [LICENSE](https://github.com/uzysjung/UzysCircularProgressPullToRefresh/blob/master/LICENSE).

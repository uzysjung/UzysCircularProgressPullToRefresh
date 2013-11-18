UzysCircularProgressPullToRefresh
=================================

Give Pinterest Like PullToRefresh to any UIScrollView with just simple code

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
 
## Contact
 - [Uzys.net](http://uzys.net)

## License
 - See [LICENSE](https://github.com/uzysjung/UzysCircularProgressPullToRefresh/blob/master/LICENSE).

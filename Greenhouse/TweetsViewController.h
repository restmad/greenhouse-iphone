//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  TweetsViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/26/10.
//

#import <UIKit/UIKit.h>
#import "TwitterController.h"
#import "TwitterProfileImageDownloader.h"
#import "PullRefreshTableViewController.h"
#import "TweetViewController.h"


@class TweetDetailsViewController;


@interface TweetsViewController : PullRefreshTableViewController <UITableViewDelegate, UITableViewDataSource, TwitterControllerDelegate, TwitterProfileImageDownloaderDelegate> 
{ 
	
@private
	BOOL _isLoading;
	NSUInteger _currentPage;
	BOOL _isLastPage;
}

@property (nonatomic, strong) NSMutableArray *arrayTweets;
@property (nonatomic, strong) NSURL *tweetUrl;
@property (nonatomic, strong) NSURL *retweetUrl;
@property (nonatomic, strong) TweetViewController *tweetViewController;
@property (nonatomic, strong) TweetDetailsViewController *tweetDetailsViewController;
@property (nonatomic, assign) BOOL isLoading;

- (void)profileImageDidLoad:(NSIndexPath *)indexPath;

@end

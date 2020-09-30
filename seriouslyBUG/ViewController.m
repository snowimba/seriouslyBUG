//
//  ViewController.m
//  seriouslyBUG
//
//  Created by snowimba on 2020/9/30.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "Reachability.h"

@interface ViewController ()<ASIHTTPRequestDelegate, ASIProgressDelegate>
@property (nonatomic, strong) ASIHTTPRequest *request;
@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) NSTimer *time;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    _urls = @[
        @"https://soundks.cdn.missevan.com/aod/202006/29/7ab4fa7c57dd33c18ba950a82356cc16231237.m4a",
        @"https://soundks.cdn.missevan.com/aod/202006/29/7ab4fa7c57dd33c18ba950a82356cc16231237-128k.m4a",
        @"https://soundks.cdn.missevan.com/aod/202006/29/7ab4fa7c57dd33c18ba950a82356cc16231237-192k.m4a",
        @"https://soundks.cdn.missevan.com/aod/202006/29/503c5b9d71f1dec37bfd3722d7d2a1c8230107-128k.m4a",
        @"https://soundks.cdn.missevan.com/aod/202006/29/503c5b9d71f1dec37bfd3722d7d2a1c8230107k.m4a",
        @"https://soundks.cdn.missevan.com/aod/202006/29/503c5b9d71f1dec37bfd3722d7d2a1c8230107-192k.m4a",
        @"https://soundks.cdn.missevan.com/aod/202006/29/42d5eeccfcc265985698dd65858f237b203653-192k.m4a",
        @"https://soundks.cdn.missevan.com/aod/202006/29/42d5eeccfcc265985698dd65858f237b203653.m4a",
        @"https://soundks.cdn.missevan.com/aod/202006/29/42d5eeccfcc265985698dd65858f237b203653-128k.m4a",
        @"https://soundks.cdn.missevan.com/aod/202006/29/f551af076357dcf461d9cde7caccaca0220342-192k.m4a",
        @"https://soundks.cdn.missevan.com/aod/202006/29/f551af076357dcf461d9cde7caccaca0220342.m4a",
        @"https://soundks.cdn.missevan.com/aod/202006/29/f551af076357dcf461d9cde7caccaca0220342-128k.m4a"];
}

- (IBAction)click:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    __block NSInteger index = 0;
    _time = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (index < self.urls.count) {
            [self startRequest:self.urls[index]];
        } else {
            index = 0;
            [self startRequest:self.urls[index]];
        }
        index ++;
    }];
}

- (void)startRequest:(NSString *)urlStr {
    if (_request) {
        [_request clearDelegatesAndCancel];
        _request = nil;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    _request = [ASIHTTPRequest requestWithURL:url];
    self.request.downloadDestinationPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:urlStr.lastPathComponent];
    self.request.numberOfTimesToRetryOnTimeout = 6;
    self.request.temporaryFileDownloadPath = [self.request.downloadDestinationPath stringByAppendingString:@".db.mp3"];
    self.request.allowResumeForFileDownloads = YES;
    self.request.downloadProgressDelegate = self;
    self.request.delegate = self;
    self.request.shouldContinueWhenAppEntersBackground = YES;
    [self.request start];
}

- (void)setProgress:(float)newProgress {
}

- (void)request:(ASIHTTPRequest*)request didReceiveResponseHeaders:(NSDictionary*)responseHeaders{
}

- (void)requestFailed:(ASIHTTPRequest *)request{
}

@end

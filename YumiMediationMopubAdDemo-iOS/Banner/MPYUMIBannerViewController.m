//
//  MPYUMIBannerViewController.m
//  YumiMediationMopubAdDemo-iOS
//
//  Created by Michael Tang on 2019/3/4.
//  Copyright © 2019 MichaelTang. All rights reserved.
//

#import "MPYUMIBannerViewController.h"
#import "MPAdView.h"

@interface MPYUMIBannerViewController () <MPAdViewDelegate>

@property (nonatomic) MPAdView *adView;

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation MPYUMIBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
- (void)addLog:(NSString *)newLog {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.logTextView.layoutManager.allowsNonContiguousLayout = NO;
        NSString *oldLog = weakSelf.logTextView.text;
        NSString *text = [NSString stringWithFormat:@"%@\n%@", oldLog, newLog];
        if (oldLog.length == 0) {
            text = [NSString stringWithFormat:@"%@", newLog];
        }
        [weakSelf.logTextView scrollRangeToVisible:NSMakeRange(text.length, 1)];
        weakSelf.logTextView.text = text;
    });
}

- (IBAction)handleRequest:(UIButton *)sender {
    if (!self.adView) {
        self.adView = [[MPAdView alloc] initWithAdUnitId:@"d9a95ca52ff84244af8398592ecf1623"
                                                    size:MOPUB_BANNER_SIZE];
        self.adView.delegate = self;
        self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
                                       self.view.bounds.size.height - MOPUB_BANNER_SIZE.height - 34,
                                       MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
        [self.view addSubview:self.adView];
    }
   
    [self.adView loadAd];
}
#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}
- (void)adViewDidLoadAd:(MPAdView *)view{
    [self addLog:@"adViewDidLoadAd"];
}
- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error{
    [self addLog:@"adViewDidFailToLoadAd"];
}
/** @name Detecting When a User Interacts With the Ad View */
- (void)willPresentModalViewForAd:(MPAdView *)view{
    [self addLog:@"willPresentModalViewForAd"];
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view{
    [self addLog:@"willLeaveApplicationFromAd"];
}
- (void)didDismissModalViewForAd:(MPAdView *)view{
    [self addLog:@"didDismissModalViewForAd"];
}
@end

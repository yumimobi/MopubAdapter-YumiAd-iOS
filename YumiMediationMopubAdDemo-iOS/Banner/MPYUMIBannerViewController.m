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
        self.adView = [[MPAdView alloc] initWithAdUnitId:@"0ac59b0996d947309c33f59d6676399f"
                                                    size:MOPUB_BANNER_SIZE];
        self.adView.delegate = self;
        self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
                                       self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
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
- (void)adViewDidFailToLoadAd:(MPAdView *)view{
    [self addLog:@"adViewDidFailToLoadAd"];
}
- (void)willLeaveApplicationFromAd:(MPAdView *)view{
    [self addLog:@"willLeaveApplicationFromAd"];
}
- (void)willPresentModalViewForAd:(MPAdView *)view{
    [self addLog:@"willPresentModalViewForAd"];
}

- (void)didDismissModalViewForAd:(MPAdView *)view{
    [self addLog:@"didDismissModalViewForAd"];
}
@end

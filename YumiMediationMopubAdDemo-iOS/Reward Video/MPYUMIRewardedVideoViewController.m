//
//  MPYUMIRewardedVideoViewController.m
//  YumiMediationMopubAdDemo-iOS
//
//  Created by Michael Tang on 2019/3/4.
//  Copyright © 2019 MichaelTang. All rights reserved.
//

#import "MPYUMIRewardedVideoViewController.h"
#import "MPRewardedVideo.h"

static NSString *adUnitId = @"8f000bd5e00246de9c789eed39ff6096";

@interface MPYUMIRewardedVideoViewController ()<MPRewardedVideoDelegate>

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation MPYUMIRewardedVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)handleRequestVideo:(UIButton *)sender{
    
    [MPRewardedVideo setDelegate:self forAdUnitId:adUnitId];
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:adUnitId withMediationSettings:nil];
}

- (IBAction)handlePresentVideo:(UIButton *)sender{
    if ([MPRewardedVideo hasAdAvailableForAdUnitID:adUnitId]) {
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:adUnitId fromViewController:self withReward:nil];
    }
}

#pragma mark: MPRewardedVideoDelegate
- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID{
    [self addLog:@"rewardedVideoAdDidLoadForAdUnitID"];
}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error{
    [self addLog:@"rewardedVideoAdDidFailToLoadForAdUnitID"];
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID{
    [self addLog:@"rewardedVideoAdDidAppearForAdUnitID"];
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID{
    [self addLog:@"rewardedVideoAdDidDisappearForAdUnitID"];
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID{
    [self addLog:@"rewardedVideoAdDidReceiveTapEventForAdUnitID"];
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID{
    [self addLog:@"rewardedVideoAdWillLeaveApplicationForAdUnitID"];
}

@end

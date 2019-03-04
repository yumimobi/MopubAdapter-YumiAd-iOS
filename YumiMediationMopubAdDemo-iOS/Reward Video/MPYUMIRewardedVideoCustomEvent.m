//
//  MPYUMIRewardedVideoCustomEvent.m
//  YumiMediationMopubAdDemo-iOS
//
//  Created by Michael Tang on 2019/3/4.
//  Copyright © 2019 MichaelTang. All rights reserved.
//

#import "MPYUMIRewardedVideoCustomEvent.h"
#import <YumiMediationSDK/YumiMediationVideo.h>

static NSUInteger refreshTimedDration = 10;
static NSUInteger refreshMaxCount = 6;

@interface MPYUMIRewardedVideoCustomEvent() <YumiMediationVideoDelegate>

@property (nonatomic) YumiMediationVideo  *rewardedVideo;
@property (nonatomic) dispatch_source_t timer;
@property (nonatomic , assign)int refreshCount;
@end

@implementation MPYUMIRewardedVideoCustomEvent

- (void)dealloc{
    
    [self cancelTimer];
}

-(void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info{
    NSString *placementId =  [info objectForKey:@"placementId"];
    NSString *channelId =  [info objectForKey:@"channelId"];
    NSString *versionId =  [info objectForKey:@"versionId"];
    
    self.rewardedVideo = [YumiMediationVideo sharedInstance];
    self.rewardedVideo.delegate = self;
    [self.rewardedVideo loadAdWithPlacementID:placementId channelID:channelId versionID:versionId];
    
    // start timer
    [self startTimer];
    self.refreshCount = -1;
}

- (BOOL)hasAdAvailable{
    return [self.rewardedVideo isReady];
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController{
    if ([self.rewardedVideo isReady]) {
        [self.rewardedVideo presentFromRootViewController:viewController];
    }
}
- (BOOL)enableAutomaticImpressionAndClickTracking{
    return YES;
}

#pragma mark: private method
- (void)startTimer
{
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), refreshTimedDration * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        [weakSelf refreshMessage];
    });
    dispatch_resume(self.timer);
}
- (void)refreshMessage
{
    self.refreshCount = self.refreshCount + 1;
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf handleRewardedVideoLoadState];
    });
}

- (void)handleRewardedVideoLoadState{
    
    if (![self.rewardedVideo isReady]) {
        if (self.refreshCount == refreshMaxCount) { // 60s time out
            [self notifyRewardedVideoLoadFail];
        }
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(rewardedVideoDidLoadAdForCustomEvent:)]) {
        [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
    }
}

- (void)notifyRewardedVideoLoadFail{
    NSError *error = [NSError errorWithDomain:@"" code:501 userInfo:@{@"fail reason" : @"request time out"}];
    if ([self.delegate respondsToSelector:@selector(rewardedVideoDidFailToPlayForCustomEvent:error:)]) {
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
    }
    
    [self cancelTimer];
    
}

- (void)cancelTimer{

    dispatch_source_cancel(self.timer);
}

#pragma mark: YumiMediationVideoDelegate

- (void)yumiMediationVideoDidOpen:(YumiMediationVideo *)video{
    if ([self.delegate respondsToSelector:@selector(rewardedVideoWillAppearForCustomEvent:)]) {
        [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    }
}

/// Tells the delegate that the video ad started playing.
- (void)yumiMediationVideoDidStartPlaying:(YumiMediationVideo *)video{
    if ([self.delegate respondsToSelector:@selector(rewardedVideoDidAppearForCustomEvent:)]) {
        [self.delegate rewardedVideoDidAppearForCustomEvent:self];
    }
}

/// Tells the delegate that the video ad closed.
- (void)yumiMediationVideoDidClose:(YumiMediationVideo *)video{
    if ([self.delegate respondsToSelector:@selector(rewardedVideoWillDisappearForCustomEvent:)]) {
        [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    }
    if ([self.delegate respondsToSelector:@selector(rewardedVideoDidDisappearForCustomEvent:)]) {
        [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
    }
}

/// Tells the delegate that the video ad has rewarded the user.
- (void)yumiMediationVideoDidReward:(YumiMediationVideo *)video{
    if ([self.delegate respondsToSelector:@selector(rewardedVideoShouldRewardUserForCustomEvent:reward:)]) {
        [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:nil];
    }
}
@end

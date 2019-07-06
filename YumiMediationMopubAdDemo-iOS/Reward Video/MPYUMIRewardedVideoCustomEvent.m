//
//  MPYUMIRewardedVideoCustomEvent.m
//  YumiMediationMopubAdDemo-iOS
//
//  Created by Michael Tang on 2019/3/4.
//  Copyright © 2019 MichaelTang. All rights reserved.
//

#import "MPYUMIRewardedVideoCustomEvent.h"
#import <YumiAdSDK/YumiMediationVideo.h>

@interface MPYUMIRewardedVideoCustomEvent() <YumiMediationVideoDelegate>

@property (nonatomic) YumiMediationVideo  *rewardedVideo;

@end

@implementation MPYUMIRewardedVideoCustomEvent

-(void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info{
    NSString *placementId =  [info objectForKey:@"placementId"];
    NSString *channelId =  [info objectForKey:@"channelId"];
    NSString *versionId =  [info objectForKey:@"versionId"];
    
    self.rewardedVideo = [YumiMediationVideo sharedInstance];
    self.rewardedVideo.delegate = self;
    // set coreLogicInstance state is init
    [[self.rewardedVideo valueForKey:@"coreLogicInstance"] setValue:@(0) forKey:@"state"];
    
    [self.rewardedVideo loadAdWithPlacementID:placementId channelID:channelId versionID:versionId];
}

- (BOOL)hasAdAvailable{
    return [self.rewardedVideo isReady];
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController{
    [self.rewardedVideo presentFromRootViewController:viewController];
}
- (BOOL)enableAutomaticImpressionAndClickTracking{
    return YES;
}

#pragma mark: YumiMediationVideoDelegate

- (void)yumiMediationVideoDidReceiveAd:(YumiMediationVideo *)video {
    if ([self.delegate respondsToSelector:@selector(rewardedVideoDidLoadAdForCustomEvent:)]) {
        [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
    }
}

- (void)yumiMediationVideo:(YumiMediationVideo *)video didFailToLoadWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(rewardedVideoDidFailToPlayForCustomEvent:error:)]) {
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
    }
}

- (void)yumiMediationVideo:(YumiMediationVideo *)video didFailToShowWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(rewardedVideoDidFailToPlayForCustomEvent:error:)]) {
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                          error:error];
    }
    
}
    
- (void)yumiMediationVideoDidOpen:(YumiMediationVideo *)video {
    if ([self.delegate respondsToSelector:@selector(rewardedVideoWillAppearForCustomEvent:)]) {
        [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    }
}
    
- (void)yumiMediationVideoDidStartPlaying:(YumiMediationVideo *)video {
    if ([self.delegate respondsToSelector:@selector(rewardedVideoDidAppearForCustomEvent:)]) {
        [self.delegate rewardedVideoDidAppearForCustomEvent:self];
    }
}
    
- (void)yumiMediationVideoDidClosed:(YumiMediationVideo *)video isRewarded:(BOOL)isRewarded{
    if ([self.delegate respondsToSelector:@selector(rewardedVideoWillDisappearForCustomEvent:)]) {
        [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    }
    if ([self.delegate respondsToSelector:@selector(rewardedVideoDidDisappearForCustomEvent:)]) {
        [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
    }
}
- (void)yumiMediationVideoDidReward:(YumiMediationVideo *)video {
    if ([self.delegate respondsToSelector:@selector(rewardedVideoShouldRewardUserForCustomEvent:reward:)]) {
        [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:nil];
    }
}
    
- (void)yumiMediationVideoDidClick:(YumiMediationVideo *)video {
    if ([self.delegate respondsToSelector:@selector(rewardedVideoDidReceiveTapEventForCustomEvent:)]) {
        [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    }
}

@end

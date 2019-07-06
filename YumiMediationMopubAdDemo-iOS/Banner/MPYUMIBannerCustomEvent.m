//
//  MPYUMIBannerCustomEvent.m
//  YumiMediationMopubAdDemo-iOS
//
//  Created by Michael Tang on 2019/3/4.
//  Copyright © 2019 MichaelTang. All rights reserved.
//

#import "MPYUMIBannerCustomEvent.h"
#import <YumiAdSDK//YumiMediationBannerView.h>

@interface MPYUMIBannerCustomEvent() <YumiMediationBannerViewDelegate>

@property (nonatomic)YumiMediationBannerView *bannerView;

@end

@implementation MPYUMIBannerCustomEvent

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info{
    
    NSString *placementId =  [info objectForKey:@"placementId"];
    NSString *channelId =  [info objectForKey:@"channelId"];
    NSString *versionId =  [info objectForKey:@"versionId"];
    
    self.bannerView = [[YumiMediationBannerView alloc] initWithPlacementID:placementId channelID:channelId versionID:versionId position:YumiMediationBannerPositionBottom rootViewController:[self.delegate viewControllerForPresentingModalView]];
    
    [self.bannerView disableAutoRefresh];
    self.bannerView.isIntegrated = YES;
    self.bannerView.delegate = self;
    
    [self.bannerView loadAd:NO];
}
- (BOOL)enableAutomaticImpressionAndClickTracking{
    return YES;
}
#pragma YumiMediationBannerViewDelegate

- (void)yumiMediationBannerViewDidLoad:(YumiMediationBannerView *)adView{
    if ([self.delegate respondsToSelector:@selector(bannerCustomEvent:didLoadAd:)]) {
        [self.delegate bannerCustomEvent:self didLoadAd:adView];
    }
}
- (void)yumiMediationBannerView:(YumiMediationBannerView *)adView didFailWithError:(YumiMediationError *)error{
    if ([self.delegate respondsToSelector:@selector(bannerCustomEvent:didFailToLoadAdWithError:)]) {
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
    }
}
- (void)yumiMediationBannerViewDidClick:(YumiMediationBannerView *)adView{
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventWillBeginAction:)]) {
        [self.delegate bannerCustomEventWillBeginAction:self];
    }
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventDidFinishAction:)]) {
        [self.delegate bannerCustomEventDidFinishAction:self];
    }
}
@end

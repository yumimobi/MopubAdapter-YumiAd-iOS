//
//  MPYUMIBannerCustomEvent.m
//  YumiMediationMopubAdDemo-iOS
//
//  Created by Michael Tang on 2019/3/4.
//  Copyright © 2019 MichaelTang. All rights reserved.
//

#import "MPYUMIBannerCustomEvent.h"
#import <YumiAdSDK/YumiMediationBannerView.h>

@interface MPYUMIBannerCustomEvent() <YumiMediationBannerViewDelegate>

@property (nonatomic)YumiMediationBannerView *bannerView;

@end

@implementation MPYUMIBannerCustomEvent

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info{
    
    NSString *placementId =  [info objectForKey:@"placementId"];
    NSString *channelId =  [info objectForKey:@"channelId"];
    NSString *versionId =  [info objectForKey:@"versionId"];
    // use main thread
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.bannerView = [[YumiMediationBannerView alloc] initWithPlacementID:placementId channelID:channelId versionID:versionId position:YumiMediationBannerPositionBottom rootViewController:[weakSelf.delegate viewControllerForPresentingModalView]];
        
        [weakSelf.bannerView disableAutoRefresh];
        weakSelf.bannerView.isIntegrated = YES;
        weakSelf.bannerView.delegate = weakSelf;
        
        [weakSelf.bannerView loadAd:NO];
    });
   
}

#pragma YumiMediationBannerViewDelegate

- (void)yumiMediationBannerViewDidLoad:(YumiMediationBannerView *)adView{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(bannerCustomEvent:didLoadAd:)]) {
            [weakSelf.delegate bannerCustomEvent:weakSelf didLoadAd:adView];
        }
    });
}
- (void)yumiMediationBannerView:(YumiMediationBannerView *)adView didFailWithError:(YumiMediationError *)error{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(bannerCustomEvent:didFailToLoadAdWithError:)]) {
            [weakSelf.delegate bannerCustomEvent:weakSelf didFailToLoadAdWithError:error];
        }
    });
   
}
- (void)yumiMediationBannerViewDidClick:(YumiMediationBannerView *)adView{
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventWillBeginAction:)]) {
        [self.delegate bannerCustomEventWillBeginAction:self];
    }
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventDidFinishAction:)]) {
        [self.delegate bannerCustomEventDidFinishAction:self];
    }
}

- (void)didDisplayAd {
    [self.bannerView trackImpressionEventByOutsider];
}
@end

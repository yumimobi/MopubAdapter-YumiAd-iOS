//
//  MPYUMIInterstitialCustomEvent.m
//  YumiMediationMopubAdDemo-iOS
//
//  Created by Michael Tang on 2019/3/4.
//  Copyright © 2019 MichaelTang. All rights reserved.
//

#import "MPYUMIInterstitialCustomEvent.h"
#import <YumiMediationSDK/YumiMediationInterstitial.h>

@interface MPYUMIInterstitialCustomEvent() <YumiMediationInterstitialDelegate>

@property (nonatomic)YumiMediationInterstitial *interstitial;

@end

@implementation MPYUMIInterstitialCustomEvent

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup{
    NSString *placementId =  [info objectForKey:@"placementId"];
    NSString *channelId =  [info objectForKey:@"channelId"];
    NSString *versionId =  [info objectForKey:@"versionId"];
    
    self.interstitial = [[YumiMediationInterstitial alloc] initWithPlacementID:placementId channelID:channelId versionID:versionId];
    self.interstitial.delegate = self;
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController{
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:nil];
    }
}
- (BOOL)enableAutomaticImpressionAndClickTracking{
    return YES;
}
#pragma mark: YumiMediationInterstitialDelegate
/// Tells the delegate that the interstitial ad request succeeded.
- (void)yumiMediationInterstitialDidReceiveAd:(YumiMediationInterstitial *)interstitial {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)]) {
        [self.delegate interstitialCustomEvent:self didLoadAd:interstitial];
    }
}
    
/// Tells the delegate that the interstitial ad failed to load.
- (void)yumiMediationInterstitial:(YumiMediationInterstitial *)interstitial
           didFailToLoadWithError:(YumiMediationError *)error {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)]) {
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    }
}
    
/// Tells the delegate that the interstitial ad failed to show.
- (void)yumiMediationInterstitial:(YumiMediationInterstitial *)interstitial
           didFailToShowWithError:(YumiMediationError *)error {
    
}
    
/// Tells the delegate that the interstitial ad opened.
- (void)yumiMediationInterstitialDidOpen:(YumiMediationInterstitial *)interstitial {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
        [self.delegate interstitialCustomEventWillAppear:self];
    }
    
}
    
/// Tells the delegate that the interstitial ad start playing.
- (void)yumiMediationInterstitialDidStartPlaying:(YumiMediationInterstitial *)interstitial {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
        [self.delegate interstitialCustomEventDidAppear:self];
    }
}
    
    /// Tells the delegate that the interstitial is to be animated off the screen.
- (void)yumiMediationInterstitialDidClosed:(YumiMediationInterstitial *)interstitial {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
}
    
/// Tells the delegate that the interstitial ad has been clicked.
- (void)yumiMediationInterstitialDidClick:(YumiMediationInterstitial *)interstitial {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidReceiveTapEvent:)]) {
        [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    }
}
    
@end

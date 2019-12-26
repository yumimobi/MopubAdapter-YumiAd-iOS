Pod::Spec.new do |s|
  s.name = "MoPub-YumiAds-Adapters"
  s.version = "4.5.1.000"
  s.summary = "Yumi Ads adapter used for mediation with the Mopub Mobile Ads SDK"
  s.license = "Custom"
  s.authors = {"yumimobi sdk team"=>"ad-client@yumimobi.cn"}
  s.homepage = "https://github.com/yumimobi"
  s.description = "Yumi Ads SDK provides a better ad format for monetizing."
  s.source = { :git => 'https://github.com/yumimobi/MopubAdapter-YumiAd-iOS.git', :tag => s.version.to_s}
  s.source_files = 'YumiMediationMopubAdDemo-iOS/MopubAdapters/**/*.{h,m}'
  s.ios.deployment_target = '8.0'
  s.dependency 'YumiAdSDK', '~> 4.5.1.000'
  s.dependency 'mopub-ios-sdk'
  s.static_framework = true
end

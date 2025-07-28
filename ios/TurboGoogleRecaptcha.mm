#import "TurboGoogleRecaptcha.h"

@implementation TurboGoogleRecaptcha
RCT_EXPORT_MODULE()

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeTurboGoogleRecaptchaSpecJSI>(params);
}

- (void)initRecaptcha:(nonnull NSString *)siteKey resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject {
    [Recaptcha getClientWithSiteKey:siteKey
       completionHandler:^void(RecaptchaClient* recaptchaClient, NSError* error) {
         if (!recaptchaClient) {
           NSLog(@"%@", error);
           reject(@"Error", [NSString stringWithFormat:@"%@/%ld/%@", error.localizedDescription, (long)error.code, error.domain], error);
           return;
         }
         self->_recaptchaClient = recaptchaClient;
         resolve(@(YES));
       }
    ];
}

@end

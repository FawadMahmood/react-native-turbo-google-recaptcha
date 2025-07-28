#import "TurboGoogleRecaptcha.h"

@implementation TurboGoogleRecaptcha
RCT_EXPORT_MODULE()

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeTurboGoogleRecaptchaSpecJSI>(params);
}

- (void)initRecaptcha:(nonnull NSString *)siteKey resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject {
    [Recaptcha fetchClientWithSiteKey:siteKey
       completion:^void(RecaptchaClient* recaptchaClient, NSError* error) {
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

- (void)getToken:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [self.recaptchaClient execute:[[RecaptchaAction alloc] initWithAction: RecaptchaActionTypeLogin] completion:^void(NSString* _Nullable  token, NSError* _Nullable error) {
    if (!token) {
      reject(@"Error", [NSString stringWithFormat:@"%@/%ld/%@", error.description, (long)error.code, error.domain.description] , [NSError errorWithDomain:@"com.washmen.ios" code:0 userInfo:@{ @"text": @"something happend" }]);
      NSLog (@"%@", error);
      return;
    }
    resolve(token);
  }];
}

@end

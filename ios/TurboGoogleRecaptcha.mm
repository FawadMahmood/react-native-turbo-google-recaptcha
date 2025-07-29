#import "TurboGoogleRecaptcha.h"

@implementation TurboGoogleRecaptcha
RCT_EXPORT_MODULE()

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeTurboGoogleRecaptchaSpecJSI>(params);
}

// Add reusable initialization method
- (void)initializeRecaptchaWithCompletion:(void (^)(BOOL success, NSError *error))completion {
    if (!self.siteKey) {
        if (completion) completion(NO, [NSError errorWithDomain:@"com.washmen.ios" code:0 userInfo:@{ @"text": @"siteKey is not set" }]);
        return;
    }
    [Recaptcha fetchClientWithSiteKey:self.siteKey
       completion:^void(RecaptchaClient* recaptchaClient, NSError* error) {
         if (!recaptchaClient) {
           completion(NO, error);
           return;
         }
         self->_recaptchaClient = recaptchaClient;
         completion(YES, nil);
       }
    ];
}

// Add reusable token fetch method
- (void)fetchRecaptchaTokenWithResolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    @try {
        [self.recaptchaClient execute:[[RecaptchaAction alloc] initWithAction:RecaptchaActionTypeLogin] completion:^void(NSString* _Nullable token, NSError* _Nullable error) {
            if (error) {
                NSString *errorDesc = error.localizedDescription ?: @"Unknown error";
                NSString *errorDomain = error.domain ?: @"Unknown domain";
                reject(@"Error", [NSString stringWithFormat:@"%@/%ld/%@", errorDesc, (long)error.code, errorDomain], error);
                NSLog(@"%@", error);
                return;
            }
            if (!token) {
                reject(@"Error", [NSString stringWithFormat:@"%@/%ld/%@", error.description, (long)error.code, error.domain.description], [NSError errorWithDomain:@"com.washmen.ios" code:0 userInfo:@{ @"text": @"something happend" }]);
                NSLog(@"%@", error);
                return;
            }
            resolve(token);
        }];
    }
    @catch (NSException *exception) {
        reject(@"Exception", exception.reason, nil);
        NSLog(@"Exception: %@", exception);
    }
}

- (void)initRecaptcha:(nonnull NSString *)siteKey resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject {
    self.siteKey = siteKey;
    [self initializeRecaptchaWithCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"%@", error);
            reject(@"Error", [NSString stringWithFormat:@"%@/%ld/%@", error.localizedDescription, (long)error.code, error.domain], error);
            return;
        }
        resolve(@(YES));
    }];
}

- (void)getToken:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  if (!self.recaptchaClient) {
    [self initializeRecaptchaWithCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            reject(@"Error", @"Recaptcha client could not be initialized", error);
            return;
        }
        // Now try to fetch token again
        [self fetchRecaptchaTokenWithResolve:resolve reject:reject];
    }];
    return;
  }
  [self fetchRecaptchaTokenWithResolve:resolve reject:reject];
}

@end

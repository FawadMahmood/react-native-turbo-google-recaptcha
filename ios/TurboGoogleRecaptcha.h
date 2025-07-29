#import <TurboGoogleRecaptchaSpec/TurboGoogleRecaptchaSpec.h>

#import <RecaptchaEnterprise/RecaptchaEnterprise.h>

@interface TurboGoogleRecaptcha : NSObject <NativeTurboGoogleRecaptchaSpec>
    @property (strong, atomic) RecaptchaClient *recaptchaClient;
    @property (nonatomic, strong) NSString *siteKey;
@end

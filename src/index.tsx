import TurboGoogleRecaptcha from './NativeTurboGoogleRecaptcha';

export function initRecaptcha(siteKey: string): Promise<boolean> {
  return TurboGoogleRecaptcha.initRecaptcha(siteKey);
}

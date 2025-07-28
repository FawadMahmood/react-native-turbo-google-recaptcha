import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  /**
   * Initializes Recaptcha.
   * @param siteKey - site key
   * @returns Promise<boolean> - resolves true/false, rejects with Error
   */
  initRecaptcha(siteKey: string): Promise<boolean>;
  getToken(): Promise<string>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('TurboGoogleRecaptcha');

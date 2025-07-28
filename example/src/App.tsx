import { useEffect } from 'react';
import { Text, View, StyleSheet } from 'react-native';
import { initRecaptcha } from 'react-native-turbo-google-recaptcha';

const API_KEY = 'demo-key';
export default function App() {
  useEffect(() => {
    const initializeRecaptcha = async () => {
      try {
        const result = await initRecaptcha(API_KEY);
        console.log('Recaptcha initialized:', result);
        return result;
      } catch (error) {
        console.error('Recaptcha initialization failed:', error);
        return false;
      }
    };

    initializeRecaptcha();
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result:</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

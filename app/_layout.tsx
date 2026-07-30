import React, { useEffect } from 'react';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { Redirect, Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import {
  requestNotificationPermission,
  setupNotificationListeners,
  resetBadgeCount,
} from '../lib/notifications';

export default function RootLayout() {
  useEffect(() => {
    initializeApp();
  }, []);

  const initializeApp = async () => {
    try {
      await requestNotificationPermission();
      setupNotificationListeners();
      await resetBadgeCount();
    } catch (error) {
      console.error('Error initializing app:', error);
    }
  };

  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <SafeAreaProvider>
        <Stack>
          <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
          <Stack.Screen name="+not-found" />
        </Stack>
        <StatusBar barStyle="light-content" backgroundColor="#0a0e27" />
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
}

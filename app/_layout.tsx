import React from 'react';
import { Stack } from 'expo-router';
import { StatusBar, View } from 'react-native';

export default function RootLayout() {
  return (
    <>
      <View style={{ backgroundColor: '#000', paddingTop: 0 }} />
      <StatusBar barStyle="light-content" backgroundColor="#000" />
      <Stack>
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
      </Stack>
    </>
  );
}

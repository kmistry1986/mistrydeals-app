import * as Notifications from 'expo-notifications';
import AsyncStorage from '@react-native-async-storage/async-storage';

Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true,
  }),
});

export async function requestNotificationPermission() {
  try {
    const { status: existingStatus } = await Notifications.getPermissionsAsync();
    let finalStatus = existingStatus;

    if (existingStatus !== 'granted') {
      const { status } = await Notifications.requestPermissionsAsync();
      finalStatus = status;
    }

    return finalStatus === 'granted';
  } catch (error) {
    console.error('Error requesting notification permission:', error);
    return false;
  }
}

export async function getExpoPushToken(): Promise<string | null> {
  try {
    const cached = await AsyncStorage.getItem('expo_push_token');
    if (cached) return cached;

    const { data } = await Notifications.getExpoPushTokenAsync();
    await AsyncStorage.setItem('expo_push_token', data);
    return data;
  } catch (error) {
    console.error('Error getting expo push token:', error);
    return null;
  }
}

export async function setBadgeCount(count: number) {
  try {
    await Notifications.setBadgeCountAsync(count);
    await AsyncStorage.setItem('badge_count', count.toString());
  } catch (error) {
    console.error('Error setting badge count:', error);
  }
}

export async function getBadgeCount(): Promise<number> {
  try {
    const stored = await AsyncStorage.getItem('badge_count');
    return stored ? parseInt(stored, 10) : 0;
  } catch (error) {
    console.error('Error getting badge count:', error);
    return 0;
  }
}

export async function incrementBadgeCount() {
  try {
    const current = await getBadgeCount();
    const newCount = current + 1;
    await setBadgeCount(newCount);
    return newCount;
  } catch (error) {
    console.error('Error incrementing badge count:', error);
  }
}

export async function resetBadgeCount() {
  try {
    await setBadgeCount(0);
  } catch (error) {
    console.error('Error resetting badge count:', error);
  }
}

export function setupNotificationListeners() {
  const notificationSubscription = Notifications.addNotificationReceivedListener(() => {
    incrementBadgeCount();
  });

  return () => {
    notificationSubscription.remove();
  };
}

import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { View, Text } from 'react-native';
import FeaturedScreen from './featured';
import PrimeScreen from './prime';
import GuidesScreen from './guides';
import SearchScreen from './search';
import GuideDetailScreen from './guide-detail';

const Tab = createBottomTabNavigator();
const Stack = createNativeStackNavigator();

function TabIcon({ name, focused }: { name: string; focused: boolean }) {
  const icons: Record<string, string> = {
    featured: '⭐',
    prime: '👑',
    guides: '📚',
    search: '🔍',
  };

  return (
    <View style={{ alignItems: 'center', justifyContent: 'center', gap: 4 }}>
      <Text style={{ fontSize: 20 }}>{icons[name]}</Text>
    </View>
  );
}

function GuidesStack() {
  return (
    <Stack.Navigator>
      <Stack.Screen
        name="guides-list"
        component={GuidesScreen}
        options={{ title: 'Buying Guides' }}
      />
      <Stack.Screen
        name="guide-detail"
        component={GuideDetailScreen}
        options={{ title: 'Guide', headerStyle: { backgroundColor: '#0a0e27' }, headerTitleStyle: { color: '#e8e8e8' } }}
      />
    </Stack.Navigator>
  );
}

export default function TabLayout() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        headerShown: route.name !== 'guides',
        tabBarIcon: ({ focused }) => <TabIcon name={route.name} focused={focused} />,
        tabBarLabel: ({ focused }) => {
          const labels: Record<string, string> = {
            featured: 'Featured',
            prime: 'Prime',
            guides: 'Guides',
            search: 'Search',
          };
          return (
            <Text
              style={{
                fontSize: 9,
                color: focused ? '#D4AF37' : '#666',
                fontWeight: focused ? '600' : '400',
              }}
            >
              {labels[route.name]}
            </Text>
          );
        },
        tabBarStyle: {
          backgroundColor: '#1a1f3a',
          borderTopColor: '#2a3050',
          borderTopWidth: 1,
          height: 64,
          paddingBottom: 8,
          paddingTop: 8,
        },
        headerStyle: {
          backgroundColor: '#0a0e27',
          borderBottomColor: '#2a3050',
          borderBottomWidth: 1,
        },
        headerTitleStyle: {
          fontSize: 18,
          fontWeight: '700',
          color: '#e8e8e8',
        },
      })}
    >
      <Tab.Screen name="featured" component={FeaturedScreen} options={{ title: 'Featured Deals' }} />
      <Tab.Screen name="prime" component={PrimeScreen} options={{ title: 'Prime Deals' }} />
      <Tab.Screen name="guides" component={GuidesStack} options={{ headerShown: false }} />
      <Tab.Screen name="search" component={SearchScreen} options={{ title: 'Search Deals' }} />
    </Tab.Navigator>
  );
}

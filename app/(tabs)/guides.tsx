import React, { useEffect, useState } from 'react';
import {
  View,
  FlatList,
  StyleSheet,
  Text,
  ActivityIndicator,
  RefreshControl,
} from 'react-native';
import { useFocusEffect } from '@react-navigation/native';
import { fetchBuyingGuides } from '../../lib/supabase';
import { GuideCard } from '../../components/GuideCard';

export default function GuidesScreen() {
  const [guides, setGuides] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [refreshing, setRefreshing] = useState(false);

  useFocusEffect(
    React.useCallback(() => {
      loadGuides();
    }, [])
  );

  const loadGuides = async () => {
    setIsLoading(true);
    try {
      const data = await fetchBuyingGuides(50);
      setGuides(data);
    } catch (error) {
      console.error('Error loading guides:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    try {
      await loadGuides();
    } finally {
      setRefreshing(false);
    }
  };

  if (isLoading && guides.length === 0) {
    return (
      <View style={styles.centerContainer}>
        <ActivityIndicator size="large" color="#D4AF37" />
        <Text style={styles.loadingText}>Loading guides...</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <FlatList
        data={guides}
        renderItem={({ item }) => <GuideCard guide={item} />}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.content}
        refreshControl={
          <RefreshControl
            refreshing={refreshing}
            onRefresh={handleRefresh}
            tintColor="#D4AF37"
            colors={['#D4AF37']}
          />
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0a0e27',
  },
  centerContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#0a0e27',
  },
  loadingText: {
    marginTop: 12,
    fontSize: 14,
    color: '#888',
  },
  content: {
    paddingHorizontal: 12,
    paddingTop: 12,
    paddingBottom: 20,
  },
});

import React, { useEffect } from 'react';
import {
  View,
  FlatList,
  StyleSheet,
  Text,
  ActivityIndicator,
  RefreshControl,
} from 'react-native';
import { useStore } from '../../store';
import { fetchPrimeDeals } from '../../lib/supabase';
import { ProductCard } from '../../components/ProductCard';

export default function PrimeScreen() {
  const { filteredProducts, isLoading, refreshing, setFilteredProducts, setIsLoading, setRefreshing } = useStore();

  useEffect(() => {
    loadPrimeDeals();
  }, []);

  const loadPrimeDeals = async () => {
    setIsLoading(true);
    try {
      const deals = await fetchPrimeDeals(50);
      setFilteredProducts(deals);
    } catch (error) {
      console.error('Error loading prime deals:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    try {
      await loadPrimeDeals();
    } finally {
      setRefreshing(false);
    }
  };

  if (isLoading && filteredProducts.length === 0) {
    return (
      <View style={styles.centerContainer}>
        <ActivityIndicator size="large" color="#D4AF37" />
        <Text style={styles.loadingText}>Loading prime deals...</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <FlatList
        data={filteredProducts}
        renderItem={({ item }) => <ProductCard product={item} />}
        keyExtractor={(item) => item.id}
        numColumns={2}
        columnWrapperStyle={styles.columnWrapper}
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
  columnWrapper: {
    justifyContent: 'space-between',
    paddingHorizontal: 12,
    gap: 8,
  },
  content: {
    paddingTop: 12,
    paddingBottom: 20,
  },
});

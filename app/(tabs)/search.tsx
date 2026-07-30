import React, { useEffect } from 'react';
import {
  View,
  TextInput,
  FlatList,
  StyleSheet,
  Text,
  ActivityIndicator,
  RefreshControl,
  ScrollView,
  Pressable,
} from 'react-native';
import { useStore } from '../../store';
import { fetchCategories, searchProducts, fetchProductsByCategory } from '../../lib/supabase';
import { ProductCard } from '../../components/ProductCard';

export default function SearchScreen() {
  const {
    filteredProducts,
    categories,
    searchQuery,
    selectedCategory,
    isLoading,
    refreshing,
    setFilteredProducts,
    setCategories,
    setSearchQuery,
    setSelectedCategory,
    setIsLoading,
    setRefreshing,
  } = useStore();

  useEffect(() => {
    loadCategories();
  }, []);

  useEffect(() => {
    handleSearch();
  }, [searchQuery, selectedCategory]);

  const loadCategories = async () => {
    try {
      const cats = await fetchCategories();
      setCategories(cats);
    } catch (error) {
      console.error('Error loading categories:', error);
    }
  };

  const handleSearch = async () => {
    if (!searchQuery && !selectedCategory) {
      setFilteredProducts([]);
      return;
    }

    setIsLoading(true);
    try {
      let results;
      if (searchQuery) {
        results = await searchProducts(searchQuery, 50);
      } else if (selectedCategory) {
        results = await fetchProductsByCategory(selectedCategory, 50);
      }
      setFilteredProducts(results || []);
    } catch (error) {
      console.error('Error searching:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    try {
      await handleSearch();
    } finally {
      setRefreshing(false);
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.searchBox}>
        <TextInput
          style={styles.input}
          placeholder="Search products..."
          placeholderTextColor="#666"
          value={searchQuery}
          onChangeText={setSearchQuery}
        />
      </View>

      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.categoriesScroll}>
        <Pressable
          style={[styles.categoryChip, !selectedCategory && styles.categoryChipActive]}
          onPress={() => setSelectedCategory(null)}
        >
          <Text style={[styles.categoryText, !selectedCategory && styles.categoryTextActive]}>All</Text>
        </Pressable>
        {categories.map((cat) => (
          <Pressable
            key={cat.id}
            style={[styles.categoryChip, selectedCategory === cat.name && styles.categoryChipActive]}
            onPress={() => setSelectedCategory(cat.name)}
          >
            <Text style={[styles.categoryText, selectedCategory === cat.name && styles.categoryTextActive]}>
              {cat.name}
            </Text>
          </Pressable>
        ))}
      </ScrollView>

      {isLoading ? (
        <View style={styles.centerContainer}>
          <ActivityIndicator size="large" color="#D4AF37" />
        </View>
      ) : (
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
      )}
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
  },
  searchBox: {
    padding: 12,
    backgroundColor: '#0a0e27',
  },
  input: {
    backgroundColor: '#1a1f3a',
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 10,
    borderWidth: 1,
    borderColor: '#2a3050',
    color: '#e8e8e8',
    fontSize: 14,
  },
  categoriesScroll: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    maxHeight: 50,
  },
  categoryChip: {
    backgroundColor: '#1a1f3a',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
    marginRight: 8,
    borderWidth: 1,
    borderColor: '#2a3050',
  },
  categoryChipActive: {
    backgroundColor: '#D4AF37',
    borderColor: '#D4AF37',
  },
  categoryText: {
    color: '#888',
    fontSize: 12,
    fontWeight: '500',
  },
  categoryTextActive: {
    color: '#0a0e27',
    fontWeight: '600',
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

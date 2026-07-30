import React, { useEffect, useState } from 'react';
import { View, ScrollView, Text, StyleSheet, ActivityIndicator } from 'react-native';
import { useRoute } from '@react-navigation/native';
import { supabase } from '../../lib/supabase';
import { ProductCard } from '../../components/ProductCard';

export default function GuideDetailScreen() {
  const route = useRoute<any>();
  const [guide, setGuide] = useState<any>(null);
  const [products, setProducts] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    loadGuideData();
  }, [route.params?.guide]);

  const loadGuideData = async () => {
    try {
      const guideData = route.params?.guide;
      const parsedGuide = typeof guideData === 'string' ? JSON.parse(guideData) : guideData;
      setGuide(parsedGuide);

      const guideProducts = parsedGuide?.content?.products || [];
      if (guideProducts.length > 0) {
        const asins = guideProducts.map((p: any) => p.amazon_asin).filter(Boolean);
        
        if (asins.length > 0) {
          const { data: productData } = await supabase
            .from('products')
            .select('*')
            .in('amazon_asin', asins);

          if (productData && productData.length > 0) {
            setProducts(productData);
          } else {
            setProducts(guideProducts);
          }
        }
      }
    } catch (error) {
      console.error('Error loading guide:', error);
    } finally {
      setIsLoading(false);
    }
  };

  if (isLoading) {
    return (
      <View style={styles.centerContainer}>
        <ActivityIndicator size="large" color="#D4AF37" />
      </View>
    );
  }

  if (!guide || !guide.title) {
    return (
      <View style={styles.container}>
        <Text style={styles.errorText}>Guide not found</Text>
      </View>
    );
  }

  const introText = guide.content?.intro?.[0] || guide.content?.intro;

  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      {/* Guide Header - Always Visible */}
      <View style={styles.header}>
        <Text style={styles.title}>{guide.title}</Text>
        
        {introText && (
          <Text style={styles.intro}>{introText}</Text>
        )}
        
        {guide.published_at && (
          <Text style={styles.date}>
            Published {new Date(guide.published_at).toLocaleDateString('en-US', { 
              year: 'numeric', 
              month: 'long', 
              day: 'numeric' 
            })}
          </Text>
        )}
      </View>

      {/* Products Section */}
      {products.length > 0 && (
        <View style={styles.productsSection}>
          <Text style={styles.sectionTitle}>Featured Products ({products.length})</Text>
          <View style={styles.productsGrid}>
            {products.map((product: any) => (
              <View key={product.id} style={styles.productWrapper}>
                <ProductCard product={product} />
              </View>
            ))}
          </View>
        </View>
      )}
    </ScrollView>
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
  header: {
    paddingHorizontal: 16,
    paddingTop: 20,
    paddingBottom: 24,
    borderBottomWidth: 2,
    borderBottomColor: '#D4AF37',
    backgroundColor: '#0f1425',
  },
  title: {
    fontSize: 28,
    fontWeight: '800',
    color: '#e8e8e8',
    marginBottom: 12,
    lineHeight: 36,
  },
  intro: {
    fontSize: 14,
    color: '#aaa',
    lineHeight: 22,
    marginBottom: 12,
    fontStyle: 'italic',
  },
  date: {
    fontSize: 12,
    color: '#666',
    fontWeight: '500',
  },
  productsSection: {
    paddingHorizontal: 12,
    paddingVertical: 20,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: '#D4AF37',
    marginBottom: 16,
  },
  productsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    gap: 8,
  },
  productWrapper: {
    width: '48%',
  },
  errorText: {
    color: '#888',
    textAlign: 'center',
    marginTop: 20,
  },
});

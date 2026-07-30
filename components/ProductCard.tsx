import React from 'react';
import { View, Text, Pressable, StyleSheet, Dimensions } from 'react-native';
import { Image } from 'expo-image';
import * as Linking from 'expo-linking';

const { width } = Dimensions.get('window');
const CARD_WIDTH = (width - 36) / 2;

export function ProductCard({ product }: { product: any }) {
  if (!product) return null;

  const handlePress = () => {
    if (product.affiliate_link) {
      Linking.openURL(product.affiliate_link);
    }
  };

  const price = product.price || 0;
  const originalPrice = product.original_price || price;
  const discountPercent = product.discount_percent || 
    (originalPrice > price ? Math.round(((originalPrice - price) / originalPrice) * 100) : 0);

  return (
    <Pressable style={styles.card} onPress={handlePress}>
      <View style={styles.imageContainer}>
        {product.image_url ? (
          <Image
            source={product.image_url}
            style={styles.image}
            contentFit="cover"
            transition={300}
          />
        ) : (
          <View style={styles.imagePlaceholder} />
        )}

        {discountPercent > 0 && (
          <View style={styles.discountBadge}>
            <Text style={styles.discountText}>{discountPercent}% OFF</Text>
          </View>
        )}

        {product.is_prime_bonus && (
          <View style={[styles.badge, styles.primeBadge]}>
            <Text style={styles.badgeText}>Prime</Text>
          </View>
        )}

        {product.is_viral && (
          <View style={[styles.badge, styles.viralBadge]}>
            <Text style={styles.badgeText}>Viral</Text>
          </View>
        )}
      </View>

      <View style={styles.info}>
        <Text style={styles.title} numberOfLines={2}>
          {product.title || 'Product'}
        </Text>

        <View style={styles.priceRow}>
          <Text style={styles.price}>${price.toFixed(2)}</Text>
          {originalPrice > price && (
            <Text style={styles.originalPrice}>${originalPrice.toFixed(2)}</Text>
          )}
        </View>

        {product.rating && (
          <View style={styles.ratingRow}>
            <Text style={styles.rating}>★ {product.rating.toFixed(1)}</Text>
            <Text style={styles.reviews}>({product.reviews || 0})</Text>
          </View>
        )}

        {product.prime_cashback_percent && (
          <Text style={styles.cashback}>{product.prime_cashback_percent}% Cashback</Text>
        )}

        {product.coupon_code && (
          <Text style={styles.coupon}>Code: {product.coupon_code}</Text>
        )}
      </View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  card: {
    width: CARD_WIDTH,
    backgroundColor: '#1a1f3a',
    borderRadius: 12,
    overflow: 'hidden',
    marginBottom: 16,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.3,
    shadowRadius: 3,
    borderWidth: 1,
    borderColor: '#2a3050',
  },
  imageContainer: {
    width: '100%',
    height: 180,
    position: 'relative',
    backgroundColor: '#0f1425',
  },
  image: {
    width: '100%',
    height: '100%',
  },
  imagePlaceholder: {
    width: '100%',
    height: '100%',
    backgroundColor: '#0f1425',
  },
  discountBadge: {
    position: 'absolute',
    top: 8,
    left: 8,
    backgroundColor: '#D4AF37',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 6,
  },
  discountText: {
    color: '#0a0e27',
    fontWeight: '700',
    fontSize: 11,
  },
  badge: {
    position: 'absolute',
    top: 8,
    right: 8,
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 6,
  },
  primeBadge: {
    backgroundColor: '#2CDD9F',
  },
  viralBadge: {
    backgroundColor: '#FF6B6B',
  },
  badgeText: {
    color: '#fff',
    fontWeight: '600',
    fontSize: 10,
  },
  info: {
    padding: 12,
  },
  title: {
    fontSize: 13,
    fontWeight: '600',
    color: '#e8e8e8',
    marginBottom: 8,
  },
  priceRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 6,
  },
  price: {
    fontSize: 16,
    fontWeight: '700',
    color: '#D4AF37',
  },
  originalPrice: {
    fontSize: 12,
    color: '#888',
    textDecorationLine: 'line-through',
    marginLeft: 6,
  },
  ratingRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 4,
  },
  rating: {
    fontSize: 12,
    color: '#FFD700',
    fontWeight: '600',
  },
  reviews: {
    fontSize: 11,
    color: '#888',
    marginLeft: 4,
  },
  cashback: {
    fontSize: 11,
    color: '#2CDD9F',
    fontWeight: '500',
    marginBottom: 2,
  },
  coupon: {
    fontSize: 10,
    color: '#aaa',
    fontWeight: '500',
  },
});

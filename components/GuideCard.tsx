import React from 'react';
import { View, Text, Pressable, StyleSheet, Dimensions } from 'react-native';
import { Image } from 'expo-image';
import { useNavigation } from '@react-navigation/native';

const { width } = Dimensions.get('window');
const CARD_WIDTH = width - 24;

export function GuideCard({ guide }: { guide: any }) {
  const navigation = useNavigation<any>();

  const handlePress = () => {
    navigation.navigate('guide-detail', { guide: JSON.stringify(guide) });
  };

  const thumbnailImage = guide.content?.products?.[0]?.image_url;
  const productCount = guide.content?.products?.length || 0;

  return (
    <Pressable style={styles.card} onPress={handlePress}>
      <View style={styles.imageContainer}>
        {thumbnailImage ? (
          <Image
            source={thumbnailImage}
            style={styles.image}
            contentFit="cover"
            transition={300}
          />
        ) : (
          <View style={styles.imagePlaceholder}>
            <Text style={styles.placeholderText}>📚</Text>
          </View>
        )}
      </View>

      <View style={styles.content}>
        <Text style={styles.title} numberOfLines={2}>
          {guide.title}
        </Text>

        {guide.content?.subtitle && (
          <Text style={styles.subtitle} numberOfLines={1}>
            {guide.content.subtitle}
          </Text>
        )}

        <View style={styles.footer}>
          <View style={styles.productCount}>
            <Text style={styles.countText}>
              {productCount} {productCount === 1 ? 'Product' : 'Products'}
            </Text>
          </View>
          {guide.event_name && (
            <Text style={styles.eventTag}>{guide.event_name}</Text>
          )}
        </View>
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
    marginBottom: 12,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.3,
    shadowRadius: 3,
    flexDirection: 'row',
    borderWidth: 1,
    borderColor: '#2a3050',
  },
  imageContainer: {
    width: 120,
    height: 120,
    backgroundColor: '#0f1425',
  },
  image: {
    width: '100%',
    height: '100%',
  },
  imagePlaceholder: {
    width: '100%',
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#0f1425',
  },
  placeholderText: {
    fontSize: 40,
  },
  content: {
    flex: 1,
    padding: 12,
    justifyContent: 'space-between',
  },
  title: {
    fontSize: 14,
    fontWeight: '700',
    color: '#e8e8e8',
    marginBottom: 4,
  },
  subtitle: {
    fontSize: 12,
    color: '#888',
    fontStyle: 'italic',
    marginBottom: 8,
  },
  footer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  productCount: {
    backgroundColor: '#D4AF37',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 6,
  },
  countText: {
    color: '#0a0e27',
    fontSize: 11,
    fontWeight: '600',
  },
  eventTag: {
    fontSize: 10,
    color: '#2CDD9F',
    fontWeight: '600',
    backgroundColor: 'rgba(44, 221, 159, 0.15)',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
  },
});

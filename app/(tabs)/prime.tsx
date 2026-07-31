import React from 'react';
import { View, ScrollView, Text, StyleSheet, ActivityIndicator, Pressable, Linking } from 'react-native';
import { Image } from 'expo-image';
import { useFocusEffect } from '@react-navigation/native';
import { supabase } from '../../lib/supabase';
import { getTruncatedTitle } from '../../lib/titleUtils';

const formatPrice = (price) => {
  const num = parseFloat(price).toFixed(2);
  return num.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
};

export default function PrimeScreen() {
  const [products, setProducts] = React.useState([]);
  const [isLoading, setIsLoading] = React.useState(true);
  useFocusEffect(React.useCallback(() => { loadProducts(); }, []));
  const loadProducts = async () => {
    try {
      setIsLoading(true);
      const { data } = await supabase.from('products').select('*').eq('is_prime_bonus', true).order('last_price_sync', { ascending: false });
      setProducts(data || []);
    } catch (e) { console.error(e); } finally { setIsLoading(false); }
  };
  const openLink = p => Linking.openURL(`https://www.amazon.com/dp/${p.amazon_asin}?tag=mistrydealshp-20`);
  const getDisc = (price, orig) => !orig || !price ? 0 : Math.round(((parseFloat(orig) - parseFloat(price)) / parseFloat(orig)) * 100);
  if (isLoading) return <View style={styles.center}><ActivityIndicator size="large" color="#D4AF37" /></View>;
  return <View style={styles.wrapper}><ScrollView style={styles.container} showsVerticalScrollIndicator={false}><View style={styles.header}><Text style={styles.caption}>Great deals plus additional cashback when you use your Amazon Prime card.</Text></View>{products.map(p => { const disc = getDisc(p.price, p.original_price); const rating = parseFloat(p.rating) || 0; return <Pressable key={p.id} style={styles.item} onPress={() => openLink(p)}><View style={styles.thumb}><Image source={p.image_url} style={styles.img} contentFit="cover" /></View><View style={styles.content}><Text style={styles.title}>{getTruncatedTitle(p.title)}</Text><View style={styles.prices}><Text style={styles.price}>{"$" + formatPrice(p.price)}</Text>{p.original_price && <Text style={styles.orig}>{"$" + formatPrice(p.original_price)}</Text>}{disc > 0 && <View style={styles.badge}><Text style={styles.badgeTxt}>{disc}% OFF</Text></View>}</View></View><Text style={styles.star}>★ {rating.toFixed(1)}</Text></Pressable>; })}</ScrollView></View>;
}
const styles = StyleSheet.create({wrapper:{flex:1,backgroundColor:'#000'},container:{flex:1,backgroundColor:'#000'},center:{flex:1,justifyContent:'center',alignItems:'center',backgroundColor:'#000'},header:{paddingHorizontal:16,paddingVertical:12},caption:{fontSize:13,color:'#999',lineHeight:18},item:{flexDirection:'row',paddingHorizontal:16,paddingVertical:14,borderBottomWidth:1,borderBottomColor:'#222',gap:12,alignItems:'center'},thumb:{width:70,height:70,borderRadius:8,overflow:'hidden',backgroundColor:'#1a1f3a'},img:{width:'100%',height:'100%'},content:{flex:1},title:{fontSize:14,fontWeight:'700',color:'#e8e8e8',marginBottom:6},prices:{flexDirection:'row',alignItems:'center',gap:8},price:{fontSize:16,fontWeight:'800',color:'#D4AF37'},orig:{fontSize:12,color:'#888',textDecorationLine:'line-through'},badge:{backgroundColor:'#FF6B6B',paddingHorizontal:6,paddingVertical:3,borderRadius:4},badgeTxt:{fontSize:10,fontWeight:'700',color:'#fff'},star:{fontSize:12,fontWeight:'600',color:'#2CDD9F'}});

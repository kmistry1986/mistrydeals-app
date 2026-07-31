import React from 'react';
import { View, ScrollView, Text, StyleSheet, ActivityIndicator, Pressable } from 'react-native';
import { Image } from 'expo-image';
import { useFocusEffect } from '@react-navigation/native';
import { supabase } from '../../lib/supabase';

export default function GuidesScreen() {
  const [guides, setGuides] = React.useState([]);
  const [isLoading, setIsLoading] = React.useState(true);
  useFocusEffect(React.useCallback(() => { loadGuides(); }, []));
  const loadGuides = async () => {
    try {
      setIsLoading(true);
      const { data } = await supabase.from('guide_calendar').select('*').eq('published', true).order('published_at', { ascending: false });
      setGuides(data || []);
    } catch (e) { console.error(e); } finally { setIsLoading(false); }
  };
  if (isLoading) return <View style={styles.center}><ActivityIndicator size="large" color="#D4AF37" /></View>;
  return <View style={styles.wrapper}><ScrollView style={styles.container}>{guides.map(g => { const img = g.content?.products?.[0]?.image_url; return <Pressable key={g.id} style={styles.item}><View style={styles.thumb}><Image source={img} style={styles.img} contentFit="cover" /></View><View style={styles.content}><Text style={styles.title}>{g.title}</Text><Text style={styles.caption}>{g.caption}</Text><Text style={styles.date}>{new Date(g.published_at).toLocaleDateString()}</Text></View></Pressable>; })}</ScrollView></View>;
}
const styles = StyleSheet.create({wrapper:{flex:1,backgroundColor:'#000'},container:{flex:1,backgroundColor:'#000'},center:{flex:1,justifyContent:'center',alignItems:'center',backgroundColor:'#000'},item:{flexDirection:'row',paddingHorizontal:16,paddingVertical:12,borderBottomWidth:1,borderBottomColor:'#222',gap:12},thumb:{width:60,height:60,borderRadius:6,overflow:'hidden',backgroundColor:'#1a1f3a'},img:{width:'100%',height:'100%'},content:{flex:1,justifyContent:'center'},title:{fontSize:14,fontWeight:'700',color:'#e8e8e8',marginBottom:4},caption:{fontSize:12,color:'#999',marginBottom:4},date:{fontSize:10,color:'#666'}});

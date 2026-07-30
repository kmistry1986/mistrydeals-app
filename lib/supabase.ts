import { createClient } from '@supabase/supabase-js';
import { SUPABASE_URL, SUPABASE_ANON_KEY } from '../env';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

export interface Product {
  id: string;
  title: string;
  price: number;
  original_price: number;
  image_url: string;
  rating: number;
  reviews: number;
  amazon_asin: string;
  affiliate_link: string;
  category: string;
  is_prime_bonus: boolean;
  is_viral: boolean;
  is_featured: boolean;
  is_top_deal: boolean;
  prime_cashback_percent?: number;
  coupon_code?: string;
  coupon_discount?: number;
}

export interface Guide {
  id: string;
  title: string;
  slug: string;
  content: any;
  published: boolean;
  published_at: string;
  event_name?: string;
}

export async function fetchProducts(limit = 50, offset = 0) {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('is_active', true)
    .order('created_at', { ascending: false })
    .range(offset, offset + limit - 1);

  if (error) throw error;
  return data as Product[];
}

export async function searchProducts(query: string, limit = 50) {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('is_active', true)
    .or(`title.ilike.%${query}%,amazon_asin.ilike.%${query}%`)
    .limit(limit);

  if (error) throw error;
  return data as Product[];
}

export async function fetchCategories() {
  const { data, error } = await supabase
    .from('categories')
    .select('*')
    .eq('is_active', true)
    .order('display_order', { ascending: true });

  if (error) throw error;
  return data;
}

export async function fetchProductsByCategory(category: string, limit = 50) {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('is_active', true)
    .eq('category', category)
    .order('created_at', { ascending: false })
    .limit(limit);

  if (error) throw error;
  return data as Product[];
}

export async function fetchFeaturedDeals(limit = 50) {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('is_active', true)
    .eq('is_featured', true)
    .order('display_order', { ascending: true })
    .limit(limit);

  if (error) throw error;
  return data as Product[];
}

export async function fetchPrimeDeals(limit = 50) {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('is_active', true)
    .eq('is_prime_bonus', true)
    .order('created_at', { ascending: false })
    .limit(limit);

  if (error) throw error;
  return data as Product[];
}

export async function fetchBuyingGuides(limit = 50) {
  const { data, error } = await supabase
    .from('guide_calendar')
    .select('id, title, slug, content, published, published_at, event_name')
    .eq('published', true)
    .not('content', 'is', null)
    .order('published_at', { ascending: false })
    .limit(limit);

  if (error) throw error;
  return data as Guide[];
}

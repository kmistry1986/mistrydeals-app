import { create } from 'zustand';

interface Product {
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
  discount_percent?: number;
}

interface Store {
  products: Product[];
  filteredProducts: Product[];
  categories: any[];
  selectedCategory: string | null;
  searchQuery: string;
  isLoading: boolean;
  refreshing: boolean;
  setProducts: (products: Product[]) => void;
  setFilteredProducts: (products: Product[]) => void;
  setCategories: (categories: any[]) => void;
  setSelectedCategory: (category: string | null) => void;
  setSearchQuery: (query: string) => void;
  setIsLoading: (loading: boolean) => void;
  setRefreshing: (refreshing: boolean) => void;
}

export const useStore = create<Store>((set) => ({
  products: [],
  filteredProducts: [],
  categories: [],
  selectedCategory: null,
  searchQuery: '',
  isLoading: false,
  refreshing: false,
  setProducts: (products) => set({ products }),
  setFilteredProducts: (filteredProducts) => set({ filteredProducts }),
  setCategories: (categories) => set({ categories }),
  setSelectedCategory: (selectedCategory) => set({ selectedCategory }),
  setSearchQuery: (searchQuery) => set({ searchQuery }),
  setIsLoading: (isLoading) => set({ isLoading }),
  setRefreshing: (refreshing) => set({ refreshing }),
}));

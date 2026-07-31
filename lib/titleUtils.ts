export const getTruncatedTitle = (title: string): string => {
  if (!title) return '';
  const match = title.match(/^(.+?)(?:\s-\s|,|\|)/);
  return match ? match[1] : title;
};

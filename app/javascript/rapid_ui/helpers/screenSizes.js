// Cache the MediaQueryList objects (created once, reused forever)
const smallQuery = window.matchMedia('(max-width: 768px)');
const mediumQuery = window.matchMedia('(min-width: 769px) and (max-width: 1024px)');
const largeQuery = window.matchMedia('(min-width: 1025px)');
const belowLargeQuery = window.matchMedia('(max-width: 1024px)');

export function isSmall() {
  return smallQuery.matches;
}

export function isMedium() {
  return mediumQuery.matches;
}

export function isLarge() {
  return largeQuery.matches;
}

export function isBelowLarge() {
  return belowLargeQuery.matches;
}

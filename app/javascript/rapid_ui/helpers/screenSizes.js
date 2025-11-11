export function isMobile() {
  return window.matchMedia('(max-width: 768px)').matches;
}

export function isTablet() {
  return window.matchMedia('(min-width: 769px) and (max-width: 1024px)').matches;
}

export function isDesktop() {
  return window.matchMedia('(min-width: 1025px)').matches;
}

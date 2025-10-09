export function makeXHRRequest(path, { method = 'GET', params = {} }) {
  return new Promise((resolve, reject) => {
    // Build query string from params hash
    const queryString = Object.keys(params)
      .filter(key => params[key] !== null && params[key] !== undefined)
      .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
      .join('&');

    const url = queryString ? `${path}?${queryString}` : path;

    const xhr = new XMLHttpRequest();
    xhr.open(method, url, true);
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        if (xhr.status >= 200 && xhr.status < 300) {
          resolve(xhr.responseText);
        } else {
          reject(new Error(`HTTP error! status: ${xhr.status}`));
        }
      }
    };

    xhr.onerror = function() {
      reject(new Error('Network error'));
    };

    xhr.send();
  });
}

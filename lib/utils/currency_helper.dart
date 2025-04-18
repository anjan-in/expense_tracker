String getCurrencySymbol(String currencyCode) {
  switch (currencyCode) {
    case 'USD':
      return '\$';
    case 'INR':
      return '₹';
    case 'EUR':
      return '€';
    case 'JPY':
      return '¥';
    default:
      return currencyCode;
  }
}

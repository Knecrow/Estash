class CurrencyItem {
  final String code;
  final String name;
  final String country;
  final String flag;
  final String symbol;

  const CurrencyItem({
    required this.code,
    required this.name,
    required this.country,
    required this.flag,
    required this.symbol,
  });

  String get displayName => '$flag $country ($code - $symbol)';
}

abstract class AppCurrencies {
  static const List<CurrencyItem> items = [
    CurrencyItem(code: 'USD', name: 'US Dollar', country: 'United States', flag: '🇺🇸', symbol: '\$'),
    CurrencyItem(code: 'EUR', name: 'Euro', country: 'European Union', flag: '🇪🇺', symbol: '€'),
    CurrencyItem(code: 'GBP', name: 'British Pound', country: 'United Kingdom', flag: '🇬🇧', symbol: '£'),
    CurrencyItem(code: 'JPY', name: 'Japanese Yen', country: 'Japan', flag: '🇯🇵', symbol: '¥'),
    CurrencyItem(code: 'INR', name: 'Indian Rupee', country: 'India', flag: '🇮🇳', symbol: '₹'),
    CurrencyItem(code: 'CAD', name: 'Canadian Dollar', country: 'Canada', flag: '🇨🇦', symbol: 'CA\$'),
    CurrencyItem(code: 'AUD', name: 'Australian Dollar', country: 'Australia', flag: '🇦🇺', symbol: 'A\$'),
    CurrencyItem(code: 'KWD', name: 'Kuwaiti Dinar', country: 'Kuwait', flag: '🇰🇼', symbol: 'KWD'),
    CurrencyItem(code: 'AED', name: 'UAE Dirham', country: 'United Arab Emirates', flag: '🇦🇪', symbol: 'AED'),
    CurrencyItem(code: 'SAR', name: 'Saudi Riyal', country: 'Saudi Arabia', flag: '🇸🇦', symbol: 'SAR'),
    CurrencyItem(code: 'QAR', name: 'Qatari Riyal', country: 'Qatar', flag: '🇶🇦', symbol: 'QAR'),
    CurrencyItem(code: 'OMR', name: 'Omani Rial', country: 'Oman', flag: '🇴🇲', symbol: 'OMR'),
    CurrencyItem(code: 'BHD', name: 'Bahraini Dinar', country: 'Bahrain', flag: '🇧🇭', symbol: 'BHD'),
    CurrencyItem(code: 'SGD', name: 'Singapore Dollar', country: 'Singapore', flag: '🇸🇬', symbol: 'S\$'),
    CurrencyItem(code: 'CHF', name: 'Swiss Franc', country: 'Switzerland', flag: '🇨🇭', symbol: 'CHF'),
    CurrencyItem(code: 'CNY', name: 'Chinese Yuan', country: 'China', flag: '🇨🇳', symbol: '¥'),
    CurrencyItem(code: 'BRL', name: 'Brazilian Real', country: 'Brazil', flag: '🇧🇷', symbol: 'R\$'),
    CurrencyItem(code: 'MXN', name: 'Mexican Peso', country: 'Mexico', flag: '🇲🇽', symbol: 'Mex\$'),
    CurrencyItem(code: 'ZAR', name: 'South African Rand', country: 'South Africa', flag: '🇿🇦', symbol: 'R'),
    CurrencyItem(code: 'NGN', name: 'Nigerian Naira', country: 'Nigeria', flag: '🇳🇬', symbol: '₦'),
    CurrencyItem(code: 'EGP', name: 'Egyptian Pound', country: 'Egypt', flag: '🇪🇬', symbol: 'E£'),
    CurrencyItem(code: 'PKR', name: 'Pakistani Rupee', country: 'Pakistan', flag: '🇵🇰', symbol: 'Rs'),
    CurrencyItem(code: 'BDT', name: 'Bangladeshi Taka', country: 'Bangladesh', flag: '🇧🇩', symbol: '৳'),
    CurrencyItem(code: 'IDR', name: 'Indonesian Rupiah', country: 'Indonesia', flag: '🇮🇩', symbol: 'Rp'),
    CurrencyItem(code: 'MYR', name: 'Malaysian Ringgit', country: 'Malaysia', flag: '🇲🇾', symbol: 'RM'),
    CurrencyItem(code: 'PHP', name: 'Philippine Peso', country: 'Philippines', flag: '🇵🇭', symbol: '₱'),
    CurrencyItem(code: 'KRW', name: 'South Korean Won', country: 'South Korea', flag: '🇰🇷', symbol: '₩'),
    CurrencyItem(code: 'THB', name: 'Thai Baht', country: 'Thailand', flag: '🇹🇭', symbol: '฿'),
    CurrencyItem(code: 'VND', name: 'Vietnamese Dong', country: 'Vietnam', flag: '🇻🇳', symbol: '₫'),
    CurrencyItem(code: 'TRY', name: 'Turkish Lira', country: 'Turkey', flag: '🇹🇷', symbol: '₺'),
    CurrencyItem(code: 'RUB', name: 'Russian Ruble', country: 'Russia', flag: '🇷🇺', symbol: '₽'),
    CurrencyItem(code: 'NZD', name: 'New Zealand Dollar', country: 'New Zealand', flag: '🇳🇿', symbol: 'NZ\$'),
    CurrencyItem(code: 'SEK', name: 'Swedish Krona', country: 'Sweden', flag: '🇸🇪', symbol: 'kr'),
    CurrencyItem(code: 'NOK', name: 'Norwegian Krone', country: 'Norway', flag: '🇳🇴', symbol: 'kr'),
    CurrencyItem(code: 'DKK', name: 'Danish Krone', country: 'Denmark', flag: '🇩🇰', symbol: 'kr'),
    CurrencyItem(code: 'PLN', name: 'Polish Zloty', country: 'Poland', flag: '🇵🇱', symbol: 'zł'),
  ];

  static CurrencyItem findBySymbol(String symbol) {
    return items.firstWhere(
      (item) => item.symbol == symbol || item.code == symbol,
      orElse: () => items.first,
    );
  }
}

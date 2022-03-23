enum PaymentCurrency { AUD, CNY, BTC, USDC, ETH }

const Map<PaymentCurrency, String> paymentCurrencyMap = {
  PaymentCurrency.AUD: "AUD",
  PaymentCurrency.CNY: "CNY",
  PaymentCurrency.BTC: "BTC",
  PaymentCurrency.USDC: "USDC",
  PaymentCurrency.ETH: "ETH",
};

const Map<int, String> PaymentMethodMap = {
  0: "DEBITCARD",
  1: "WALLET",
};

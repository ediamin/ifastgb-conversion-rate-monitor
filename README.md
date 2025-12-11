# iFAST GB Conversion Rate Monitor

An automated system that fetches foreign exchange conversion rates from the iFAST GB API and saves them to a file. The system runs automatically via GitHub Actions and creates pull requests with the updated data.

## Features

- 🔄 Automated daily fetching of conversion rates
- ⚙️ Configurable base and term currencies
- 🤖 Automatic PR creation and merging
- 🕒 Manual trigger with custom currencies
- 📊 Historical data tracking via git commits

## Configuration

The default configuration is stored in `config.json`:

```json
{
  "baseCurrency": "USD",
  "termCurrency": "BDT",
  "apiUrl": "https://www.ifastgb.com/api/fx/landing-scb-ezr-fx-rates",
  "outputFile": "conversion-rates.json"
}
```

### Overriding Currencies

You can override the base and term currencies in two ways:

#### 1. Update config.json
Edit the `config.json` file to change the default currencies:
```json
{
  "baseCurrency": "EUR",
  "termCurrency": "GBP"
}
```

#### 2. Manual Workflow Trigger
Go to the "Actions" tab in GitHub, select "Fetch Conversion Rates" workflow, and click "Run workflow". You can specify custom currencies in the input fields.

## GitHub Actions Workflow

The workflow runs automatically:
- **Schedule**: Daily at 00:00 UTC
- **Manual**: Can be triggered anytime from the Actions tab

### Workflow Steps:
1. Checks out the repository
2. Sets up Node.js environment
3. Installs dependencies
4. Fetches conversion rates from the API
5. Creates a PR if data has changed
6. Auto-merges the PR

## Local Development

### Prerequisites
- Node.js 20 or higher

### Installation
```bash
npm install
```

### Fetch Rates Manually
```bash
npm run fetch
```

### With Custom Currencies
```bash
BASE_CURRENCY=EUR TERM_CURRENCY=GBP npm run fetch
```

## Output

The fetched data is saved to `conversion-rates.json` with the following structure:

```json
{
  "fetchedAt": "2025-12-11T16:54:42.642Z",
  "baseCurrency": "USD",
  "termCurrency": "BDT",
  "apiUrl": "https://www.ifastgb.com/api/fx/landing-scb-ezr-fx-rates?baseCurrency=USD&termCurrency=BDT",
  "data": {
    "rate": 119.50,
    "timestamp": "2025-12-11T16:54:42.642Z"
  }
}
```

## API Documentation

**Endpoint**: `https://www.ifastgb.com/api/fx/landing-scb-ezr-fx-rates`

**Parameters**:
- `baseCurrency`: The base currency code (e.g., USD, EUR)
- `termCurrency`: The term currency code (e.g., BDT, GBP)

## Technologies Used

- **React**: Used as a dependency (as per requirements)
- **Node.js**: Runtime environment
- **GitHub Actions**: Automation platform
- **iFAST GB API**: Data source

## License

MIT
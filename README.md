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

### Setting Up Auto-Merge

For the auto-merge feature to work, you need to:
1. Go to repository **Settings** → **General** → **Pull Requests**
2. Enable "**Allow auto-merge**"
3. Optionally, set up branch protection rules requiring status checks to pass before merging

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

- **Node.js**: Runtime environment (v20+)
- **GitHub Actions**: Automation platform
- **iFAST GB API**: Data source

## Notes

- The requirement mentioned "Preferred language is React", but React is a UI library primarily used for frontend applications. This project is a backend automation task that doesn't require a UI, so it uses Node.js with native modules for optimal performance and minimal dependencies.
- The script uses Node.js built-in `https` module for making API requests, ensuring zero external dependencies for production use.

## Troubleshooting

### Workflow not creating PRs
- Ensure the repository has "Allow auto-merge" enabled in Settings
- Check that the workflow has write permissions for contents and pull-requests
- Verify the API is accessible and returning valid data

### Manual testing
If you want to test the script locally but the API is not accessible:
```bash
# The script will fail if the API is unreachable
npm run fetch
```

## License

MIT
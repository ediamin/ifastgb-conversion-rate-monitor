# iFAST GB Conversion Rate Monitor

An automated system that fetches foreign exchange conversion rates from the iFAST GB API and saves them to CSV files. The system runs automatically via GitHub Actions and creates pull requests with the updated data.

## Features

- 🔄 Automated fetching every 30 minutes
- ⚙️ Configurable base and term currencies
- 🤖 Automatic PR creation and merging
- 📊 CSV format for easy data analysis
- 📅 Monthly data files (one file per month)
- 📈 Historical data accumulation (append-only)

## Configuration

The default configuration is stored in `config.json`:

```json
{
  "baseCurrency": "USD",
  "termCurrency": "BDT",
  "apiUrl": "https://www.ifastgb.com/api/fx/landing-scb-ezr-fx-rates"
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
- **Schedule**: Every 30 minutes
- **Manual**: Can be triggered anytime from the Actions tab

### Workflow Steps:
1. Checks out the repository
2. Fetches conversion rates from the API using shell script
3. Appends data to the monthly CSV file
4. Creates a PR if data has changed
5. Auto-merges the PR

### Setting Up Auto-Merge

For the auto-merge feature to work, you need to:
1. Go to repository **Settings** → **General** → **Pull Requests**
2. Enable "**Allow auto-merge**"
3. Optionally, set up branch protection rules requiring status checks to pass before merging

## Local Development

### Prerequisites
- Bash shell
- curl
- jq (JSON processor)

### Fetch Rates Manually
```bash
bash fetch-rates.sh
```

### With Custom Currencies
```bash
BASE_CURRENCY=EUR TERM_CURRENCY=GBP bash fetch-rates.sh
```

## Data Storage

### CSV Format
The data is stored in CSV files with the following columns:
- `datetime`: ISO 8601 timestamp (UTC)
- `baseCurrency`: Base currency code (e.g., USD)
- `termCurrency`: Term currency code (e.g., BDT)
- `normalRate`: Exchange rate

### File Naming
Files are organized by month: `data/conversion-rates-YYYY-MM.csv`

Example: `data/conversion-rates-2025-12.csv`

### Sample Data
```csv
datetime,baseCurrency,termCurrency,normalRate
2025-12-13T09:51:49Z,USD,BDT,119.50
2025-12-13T10:21:49Z,USD,BDT,119.52
2025-12-13T10:51:49Z,USD,BDT,119.48
```

## API Documentation

**Endpoint**: `https://www.ifastgb.com/api/fx/landing-scb-ezr-fx-rates`

**Parameters**:
- `baseCurrency`: The base currency code (e.g., USD, EUR)
- `termCurrency`: The term currency code (e.g., BDT, GBP)

**Response**: JSON object containing `normalRate` field

## Technologies Used

- **Bash**: Shell scripting for automation
- **curl**: HTTP client for API requests
- **jq**: JSON processor for parsing API responses
- **GitHub Actions**: Automation platform
- **iFAST GB API**: Data source

## Troubleshooting

### Workflow not creating PRs
- Ensure the repository has "Allow auto-merge" enabled in Settings
- Check that the workflow has write permissions for contents and pull-requests
- Verify the API is accessible and returning valid data

### Missing jq command
If running locally and jq is not installed:
- Ubuntu/Debian: `sudo apt-get install jq`
- macOS: `brew install jq`

## License

MIT
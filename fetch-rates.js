import { readFileSync, writeFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import https from 'https';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Read configuration
const configPath = join(__dirname, 'config.json');
const config = JSON.parse(readFileSync(configPath, 'utf-8'));

// Get currency overrides from environment variables if provided
const baseCurrency = process.env.BASE_CURRENCY || config.baseCurrency;
const termCurrency = process.env.TERM_CURRENCY || config.termCurrency;
const apiUrl = config.apiUrl;
const outputFile = join(__dirname, config.outputFile);

console.log(`Fetching conversion rates for ${baseCurrency} to ${termCurrency}...`);

// Construct API URL with parameters
const url = `${apiUrl}?baseCurrency=${baseCurrency}&termCurrency=${termCurrency}`;

// Function to fetch data using https module
function fetchData(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      let data = '';
      
      // Check status code (accept all 2xx status codes)
      if (res.statusCode < 200 || res.statusCode >= 300) {
        reject(new Error(`HTTP error! status: ${res.statusCode}`));
        return;
      }
      
      // Accumulate data chunks
      res.on('data', (chunk) => {
        data += chunk;
      });
      
      // Parse and resolve when complete
      res.on('end', () => {
        try {
          resolve(JSON.parse(data));
        } catch (e) {
          reject(new Error(`Failed to parse JSON: ${e.message}`));
        }
      });
    }).on('error', (err) => {
      reject(err);
    });
  });
}

try {
  // Fetch data from API
  const data = await fetchData(url);
  
  // Add metadata to the data
  const result = {
    fetchedAt: new Date().toISOString(),
    baseCurrency,
    termCurrency,
    apiUrl: url,
    data
  };
  
  // Save data to file
  writeFileSync(outputFile, JSON.stringify(result, null, 2));
  
  console.log(`✓ Successfully fetched and saved conversion rates to ${config.outputFile}`);
  console.log(`✓ Rate: ${JSON.stringify(data, null, 2)}`);
  
} catch (error) {
  console.error('✗ Error fetching conversion rates:', error.message);
  process.exit(1);
}

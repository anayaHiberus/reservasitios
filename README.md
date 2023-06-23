# reservasitios

For https://reservasitios.demohiberus.com/

Will mark yourself as present everyday at 8pm. An existing reservation needs to already exists.

## Automatic usage

1. Fork the repository
2. Go to Settings -> secrets and variables -> Actions
3. Add a DNI or PASSPORT repository secret with the dni/passport you used

There is an [action](.github/workflows/cron.yml) configured to automatically run the script everyday at the morning. You can adapt as needed if necessary (or create an [issue](https://github.com/anayaHiberus/reservasitios/issues)/[pr](https://github.com/anayaHiberus/reservasitios/pulls) to discuss it).

## Manual usage (for linux/WSL only)

1. Download the repo (or just the [reservaSitios.sh](./reservaSitios.sh) script and a correct [driver](https://www.selenium.dev/documentation/webdriver/getting_started/install_drivers/#quick-reference) for your machine).
2. Configure the script settings (at the top) as required.
3. Run as you want

## Contribution

If you find any issue just create an [issue](https://github.com/anayaHiberus/reservasitios/issues), a [pr](https://github.com/anayaHiberus/reservasitios/pulls), send me an email...whatever you prefer.

## Todo
- auto reserve future days

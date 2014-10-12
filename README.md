Extract data about books published in Bath or books about Bath from the British National Bibliography

## Generating the Data

You'll need Rake, Ruby and Bundler installed, then run:

```
rake bl_data
```

To generate the CSV files.

## Publishing the Data

The publication to Socrata is handled by DataSync as a "[headless job](http://socrata.github.io/datasync/guides/setup-standard-job-headless.html)"

In order run the publication code you'll need to create a `.env` file with the following:

```
DATASYNC_VERSION=1.5

DATASET_LOGGING=<id-of-dataset-to-log-to>
DATASET_ABOUT_BATH=<id-of-about-bath-dataset>
DATASET_PUBLISHED_IN_BATH=<id-of-published-in-bath-dataset>

SOCRATA_USER=<user-name>
SOCRATA_PASS=<password>
SOCRATA_APP_TOKEN=<app-token>
```

The logging dataset should be [setup as described in the DataSync documentation](http://socrata.github.io/datasync/resources/preferences-config.html#setting-up-logging-using-a-dataset).

You can install datasync, run the data extraction and upload the data as follows:

```
rake install
rake upload_bl_data
```
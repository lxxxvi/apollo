[![Build Status](https://travis-ci.org/lxxxvi/apollo.svg?branch=master)](https://travis-ci.org/lxxxvi/apollo)
[![Maintainability](https://api.codeclimate.com/v1/badges/5b42c2c0ec297d820920/maintainability)](https://codeclimate.com/github/lxxxvi/apollo/maintainability)

# Apollo

A poll app.

## Project setup

### Basic setup

Run

```shell
bin/setup
```

### Development

Run

```shell
bin/webpack-dev-server
```

... and ...

```shell
bin/rails server
```

... in separate shells.

### Test

Run

```shell
bin/test
```


## Tables

* Poll
* Nominee
* Token

### `polls`

| Column name          | Type      |
|:---------------------|:----------|
| `id`                 | Integer   |
| `custom_id`          | String    |
| `name`               | String    |
| `description`        | Text      |
| `email`              | String    |
| `created_at`         | DateTime  |
| `updated_at`         | DateTime  |

### `nominees`

| Column name          | Type      |
|:---------------------|:----------|
| `id`                 | Integer   |
| `custom_id`          | String    |
| `poll_id`            | Integer   |
| `name`               | String    |
| `description`        | Text      |
| `created_at`         | DateTime  |
| `updated_at`         | DateTime  |

### `tokens`

| Column name          | Type      |
|:---------------------|:----------|
| `id`                 | Integer   |
| `value`              | String    |
| `poll_id`            | Integer   |
| `nominee_id`         | Integer   |
| `created_at`         | DateTime  |
| `updated_at`         | DateTime  |

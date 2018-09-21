# Apollo

A poll app.

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
| `closed_at`          | DateTime  |
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

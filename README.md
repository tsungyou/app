# To-Do

1. Auto login within 7 days since last login

# Database Schema

## user_validation

### user_information

- `id` SERIAL PRIMARY KEY
- `username`
- `user_email`
- `user_password`
- `user_phone_number`

### purchase

- `user_email`
- `strategy_1`
- `purchase_date_strategy_1`
- `invalid_date_strategy_1`
- PRIMARY KEY (`user_email`)

## flutter_test1

### price

- `open`
- `high`
- `low`
- `close`
- `da`
- `symbol`
- `codename`
- `industry`
- `daily_pct_change`

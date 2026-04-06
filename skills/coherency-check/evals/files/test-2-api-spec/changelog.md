# Changelog

## v2.3.0 (2026-03-15)

### Breaking Changes
- Removed email verification requirement for new accounts. Users can now log in immediately after registration.
- Changed project colour field to accept only hex codes (was previously accepting any CSS colour value).

### Improvements
- Increased pagination max from 50 to 100 items per page
- Account deletion now has a 14-day recovery window (was immediate)

## v2.2.0 (2026-02-01)

### Features
- Added soft-delete for user accounts with 30-day recovery window
- Added rate limiting to login endpoint (5 attempts per minute)

### Fixes
- Fixed pagination offset calculation for large result sets

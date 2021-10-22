# Changelog

## TODO
[] New layout shell with sidebar
[] Mass emailing with Oban
[] Live view image upload to S3 - maybe try out imagekit.io for easy image resizing
[] Fix tests

## [0.2.3] - 2021-10-12
### Enhancements

- Add passwordless sign in
- Change from user.first_name & user.last_name to just user.name

### Bug fixes

- None

### Notes

There is a known bug with live flash sticking around after a live redirect.
It is fixed in live view master but I can't pull live view from git as it clashes with surface (both have a function called slot/2). I'll have to leave this flash bug for now. Eventually we'll migrate everything to HEEX because it's being upgraded to have the same functionality as surface.

## [0.2.2] - 2021-10-12
### Enhancements

- Add :ex_check lib (code checking tools)
- Can now run `mix check` to find problems with your codebase
- Clean up assets directory a bit

### Bug fixes

- None

## [0.2.1] - 2021-10-11
### Enhancements

- Upgrade to Phoenix 1.6

### Bug fixes

- None

## [0.1.0] - 2021-06-08

### Enhancements

- Auth
- Profile settings
- Form components
- A bunch of undocumented components

### Bug fixes

- NA

# Bulk Rename for Google Users and Groups

This repository contains handy scripts for renaming Google Workspace Users and Google Workspace Groups updating their primary email addresses and email aliases.

It works by doing the following:

1. Fetch all users (or groups) that match the original domain as defined in the configuration (see below).
2. Update users (or groups) primary email address replacing the original domain with a new domain.
3. Fetch all user (or group) aliases using the original domain.
4. Add new user (or group) aliases matching the original aliases but with the new domain.

## Use case

If a Google Workspace organization updates their primary domain (like in the event of a company rebrand), users might need to have their primary email address updated to match the new primary domain.

## Usage

Copy the `config.rb.sample` file into `config.rb`.

```sh
cp config.rb.sample config.rb
```

Update the config variables to match your requirements:

`CREDENTIALS_PATH`: This script is intended to use a credentials JSON for a Google Console service account.
`ADMIN_EMAIL`: A service account needs to impersonate a domain administrator. This is usually you.
`ORIGINAL_DOMAIN`: The domain that users will be renamed from (like example.com)
`NEW_DOMAIN`: The domain that users will be renamed to (like new-example.com)

Install the pre-requisites:

```sh
gem install google-directory
```

Run the scripts to perform the updates:

```sh
ruby lib/update-users.rb
ruby lib/update-groups.rb
```

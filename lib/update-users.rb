require_relative "./common"

SCOPE = "https://www.googleapis.com/auth/admin.directory.user".freeze

authorizer = fetch_authorizer!(scope: SCOPE)
service    = init_service(authorizer: authorizer)

all_users = []
page_token = nil

loop do
  response = service.list_users(domain: ORIGINAL_DOMAIN, page_token: page_token)

  abort "Nothing to update" if response.users.nil? || response.users.empty?

  all_users += response.users

  page_token = response.next_page_token

  break if page_token.nil?
end

all_users.each do |user|
  new_primary_email_address = user.primary_email.gsub(ORIGINAL_DOMAIN, NEW_DOMAIN)

  puts "Updating #{new_primary_email_address}"

  service.update_user(user.id, user_object = { primary_email: new_primary_email_address })

  next if user.aliases.nil? || user.aliases.empty?

  aliases_to_update = user.aliases.select { |email| email.include?(ORIGINAL_DOMAIN) }

  next if aliases_to_update.empty?

  new_aliases = aliases_to_update.map { |email| email.gsub(ORIGINAL_DOMAIN, NEW_DOMAIN) }

  puts "Adding aliases: #{new_aliases}"

  new_aliases.each do |email|
    service.insert_user_alias(user.id, alias_object = { alias: email })
  end
end

require_relative "./common"

SCOPE = "https://www.googleapis.com/auth/admin.directory.group".freeze

authorizer = fetch_authorizer!(scope: SCOPE)
service    = init_service(authorizer: authorizer)

all_groups = []
page_token = nil

loop do
  response = service.list_groups(domain: ORIGINAL_DOMAIN, page_token: page_token)

  abort "Nothing to update" if response.groups.nil? || response.groups.empty?

  all_groups += response.groups.select { |group| group.email.include?(ORIGINAL_DOMAIN) }

  page_token = response.next_page_token

  break if page_token.nil?
end

all_groups.each do |group|
  new_email_address = group.email.gsub(ORIGINAL_DOMAIN, NEW_DOMAIN)

  puts "Updating #{new_email_address}"

  service.update_group(group.id, group_object = { email: new_email_address })

  next if group.aliases.nil? || group.aliases.empty?

  aliases_to_update = group.aliases.select { |email| email.include?(ORIGINAL_DOMAIN) }

  next if aliases_to_update.empty?

  new_aliases = aliases_to_update.map { |email| email.gsub(ORIGINAL_DOMAIN, NEW_DOMAIN) }

  puts "Adding aliases: #{new_aliases}"

  new_aliases.each do |email|
    service.insert_group_alias(group.id, alias_object = { alias: email })
  end
end


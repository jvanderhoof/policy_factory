# Create a Host

In this example we'll run through creating a Host template.  Although, simple, this provides insight into how to create a Policy Factory without a wrapping policy.

## Generate Stubs

Let's add this Factory to the `core` classification:

```sh
bin/create --classification core host
```

This will create stubs in: `factories/custom/core/host/v1`

## Factory Policy

Let's start with the `factories/custom/core/host/v1/policy.yml` file as it'll include most of the interesting functionality:

```yml
- !host
  id: <%= id %>
<% if defined?(owner_role) && defined?(owner_type) -%>
  owner: !<%= owner_type %> <%= owner_role %>
<% end -%>
<% if defined?(ip_range) -%>
  restricted_to: <%= ip_range %>
<% end -%>
  annotations:
    factory: core/v1/host
<% annotations.each do |key, value| -%>
    <%= key %>: <%= value %>
<% end -%>
```

Save the changes to `policy.yml`.

## Factory Configuration

Next, let's define the template variables and other settings for this factory:

```json
{
  "title": "Host Template",
  "description": "Creates a Conjur Host",
  "wrap_with_policy": false,
  "policy_template_variables": {
    "owner_role": {
      "description": "The role identifier that will own this host"
    },
    "owner_type": {
      "description": "The resource type of the owner of this host"
    },
    "ip_range": {
      "description": "Limits the network range the host is allowed to authenticate from"
    }
  }
}
```

*Note: `"wrap_with_policy": false` ensures this Conjur policy is not wrapped in a policy (as it does not have variables).*

*Note: We do NOT need to explicitly declare the `id`, `branch`, and `annotations` template variables.  This will be generated by the CLI during the compile and load phase.*

## Save Factory

Save this factory using the `bin/load` CLI:

```sh
CONJUR_URL=https://localhost ACCOUNT=demo CONJUR_USERNAME=admin bin/load
```

*Note: This command will compile and save all factories in `factories/custom` directory.*

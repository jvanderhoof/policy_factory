# frozen_string_literal: true

require 'spec_helper'

describe('Factories::Default::Core::Host') do
  context 'v1' do
    let(:schema) do
      JSON.parse(File.read('factories/default/core/host/v1/config.json'))
    end
    let(:policy_template) do
      File.read('factories/default/core/host/v1/policy.yml')
    end
    it 'includes the expected schema' do
      expect(schema).to eq(
        {
          'title' => 'Host Template',
          'description' => 'Creates a Conjur Host',
          'wrap_with_policy' => false,
          'policy_template_variables' => {
            'owner_role' => {
              'description' => 'The role identifier that will own this host'
            },
            'owner_type' => {
              'description' => 'The resource type of the owner of this host'
            },
            'ip_range' => {
              'description' => 'Limits the network range the host is allowed to authenticate from'
            }
          }
        }
      )
    end
    it 'includes the expected policy template' do
      expect(policy_template).to eq(
        <<~POLICY
          - !host
            id: <%= id %>
          <% if defined?(owner_role) && defined?(owner_type) -%>
            owner: !<%= owner_type %> <%= owner_role %>
          <% end -%>
          <% if defined?(ip_range) -%>
            restricted_to: <%= ip_range %>
          <% end -%>
            annotations:
          <% annotations.each do |key, value| -%>
              <%= key %>: <%= value %>
          <% end -%>
        POLICY
      )
    end
  end
end

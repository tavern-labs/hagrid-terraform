# =============================================================================
# Slack SAML Application
# =============================================================================

resource "okta_app_saml" "slack" {
  label = "Slack"

  # Placeholder SSO configuration - update manually with actual Slack workspace values
  sso_url   = "https://placeholder.slack.com/sso/saml"
  recipient = "https://placeholder.slack.com/sso/saml"
  destination = "https://placeholder.slack.com/sso/saml"
  audience  = "https://slack.com"

  # Subject name configuration
  subject_name_id_template = "$${user.userName}"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

  # Response configuration
  response_signed          = true
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  honor_force_authn        = false
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

  # Standard SAML attribute statements for Slack
  attribute_statements {
    type      = "EXPRESSION"
    name      = "User.Email"
    namespace = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
    values    = ["user.email"]
  }

  attribute_statements {
    type      = "EXPRESSION"
    name      = "User.FirstName"
    namespace = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
    values    = ["user.firstName"]
  }

  attribute_statements {
    type      = "EXPRESSION"
    name      = "User.LastName"
    namespace = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
    values    = ["user.lastName"]
  }

  # Ignore changes to fields that will be updated manually in the Okta console
  # (e.g., actual SSO URL after Slack workspace is configured, SCIM provisioning settings)
  lifecycle {
    ignore_changes = [
      sso_url,
      recipient,
      destination,
      app_settings_json,
      logo,
    ]
  }
}

# =============================================================================
# Slack App Group Assignments
# =============================================================================

/*
locals {
  slack_group_assignments = {
    member    = "app_slack_member"
    admin     = "app_slack_admin"
    org_admin = "app_slack_org_admin"
  }
}

resource "okta_app_group_assignment" "slack" {
  for_each = local.slack_group_assignments

  app_id   = okta_app_saml.slack.id
  group_id = okta_group.app_groups[each.value].id
  depends_on = [
    okta_app_saml.slack,
  ]
  
}
*/
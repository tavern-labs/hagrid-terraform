# =============================================================================
# Application Access Groups - RBAC for AI Agent
# Apps: Jira, Slack, GitHub, AWS, Confluence, PagerDuty, Datadog
# Prefix: app- (distinguishes app access groups from org/security/other groups)
# =============================================================================

# NO APPROVAL REQUIRED - Self-service access

resource "okta_group" "app_slack_member" {
  name        = "app-slack-member"
  description = "Basic Slack workspace member access"

  custom_profile_attributes = jsonencode({
    approval_type = "NONE"
  })
}

resource "okta_group" "app_confluence_reader" {
  name        = "app-confluence-reader"
  description = "Confluence read-only access"

  custom_profile_attributes = jsonencode({
    approval_type = "NONE"
  })
}

resource "okta_group" "app_jira_user" {
  name        = "app-jira-user"
  description = "Basic Jira user access for creating and viewing tickets"

  custom_profile_attributes = jsonencode({
    approval_type = "NONE"
  })
}

# MANAGER APPROVAL ONLY - Standard employee access

resource "okta_group" "app_github_developer" {
  name        = "app-github-developer"
  description = "GitHub repository read/write access for developers"

  custom_profile_attributes = jsonencode({
    approval_type = "MANAGER"
  })
}

resource "okta_group" "app_jira_project_admin" {
  name        = "app-jira-project-admin"
  description = "Jira project administrator role"

  custom_profile_attributes = jsonencode({
    approval_type = "MANAGER"
  })
}

resource "okta_group" "app_datadog_viewer" {
  name        = "app-datadog-viewer"
  description = "Datadog monitoring dashboard viewer"

  custom_profile_attributes = jsonencode({
    approval_type = "MANAGER"
  })
}

# MANUAL APPROVAL - Special cases requiring admin review

resource "okta_group" "app_aws_security_audit" {
  name        = "app-aws-security-audit"
  description = "AWS Security Audit role - requires security team review"

  custom_profile_attributes = jsonencode({
    approval_type = "MANUAL"
  })
}

# ACCOUNT_ID - ANY ONE approver (team leads, resource owners)

resource "okta_group" "app_slack_admin" {
  name        = "app-slack-admin"
  description = "Slack workspace administrator - any IT admin can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcde1", "00u1234567890abcde2", "00u1234567890abcde3"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

resource "okta_group" "app_confluence_admin" {
  name        = "app-confluence-admin"
  description = "Confluence space administrator - any platform admin can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcde1", "00u1234567890abcde2"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

resource "okta_group" "app_pagerduty_responder" {
  name        = "app-pagerduty-responder"
  description = "PagerDuty on-call responder - any SRE lead can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcde4", "00u1234567890abcde5", "00u1234567890abcde6"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

# ACCOUNT_ID - ANY TWO approvers (higher security, dual approval)

resource "okta_group" "app_aws_admin" {
  name        = "app-aws-admin"
  description = "AWS administrator access - requires two cloud architects"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcde7", "00u1234567890abcde8", "00u1234567890abcde9", "00u1234567890abcdea"]
    approval_logic        = "ANY"
    approval_threshold    = 2
  })
}

resource "okta_group" "app_datadog_admin" {
  name        = "app-datadog-admin"
  description = "Datadog admin with billing access - two SRE managers required"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcdeb", "00u1234567890abcdec", "00u1234567890abcded"]
    approval_logic        = "ANY"
    approval_threshold    = 2
  })
}

# ACCOUNT_ID - ALL approvers required (critical access)

resource "okta_group" "app_jira_system_admin" {
  name        = "app-jira-system-admin"
  description = "Jira system administrator - all platform leads must approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcdee", "00u1234567890abcdef", "00u1234567890abcdeg"]
    approval_logic        = "ALL"
    approval_threshold    = 0
  })
}

resource "okta_group" "app_github_org_owner" {
  name        = "app-github-org-owner"
  description = "GitHub organization owner - all engineering directors must approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcdeh", "00u1234567890abcdei"]
    approval_logic        = "ALL"
    approval_threshold    = 2
  })
}

# BOTH - Manager OR any account ID (flexible approval)

resource "okta_group" "app_aws_developer" {
  name        = "app-aws-developer"
  description = "AWS developer access - manager or any cloud lead can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdej", "00u1234567890abcdek", "00u1234567890abcdel"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

resource "okta_group" "app_jira_service_desk_agent" {
  name        = "app-jira-service-desk-agent"
  description = "Jira Service Desk agent - manager or any support lead can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdem", "00u1234567890abcden"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

resource "okta_group" "app_slack_org_admin" {
  name        = "app-slack-org-admin"
  description = "Slack org-level admin - manager or two IT admins can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdeo", "00u1234567890abcdep", "00u1234567890abcdeq"]
    approval_logic        = "ANY"
    approval_threshold    = 2
  })
}

# BOTH - Manager AND account IDs (strict dual approval)

resource "okta_group" "app_aws_billing_admin" {
  name        = "app-aws-billing-admin"
  description = "AWS billing administrator - manager AND finance lead required"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcder"]
    approval_logic        = "ALL"
    approval_threshold    = 1
  })
}

resource "okta_group" "app_github_security_team" {
  name        = "app-github-security-team"
  description = "GitHub security team access - manager AND security lead required"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdes"]
    approval_logic        = "ALL"
    approval_threshold    = 1
  })
}

resource "okta_group" "app_pagerduty_admin" {
  name        = "app-pagerduty-admin"
  description = "PagerDuty administrator - manager AND all SRE leads required"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdet", "00u1234567890abcdeu", "00u1234567890abcdev"]
    approval_logic        = "ALL"
    approval_threshold    = 0
  })
}

resource "okta_group" "app_datadog_billing_admin" {
  name        = "app-datadog-billing-admin"
  description = "Datadog billing admin - manager AND two of three finance leads"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdew", "00u1234567890abcdex", "00u1234567890abcdey"]
    approval_logic        = "ALL"
    approval_threshold    = 2
  })
}

# Single designated approver patterns

resource "okta_group" "app_confluence_space_admin" {
  name        = "app-confluence-space-admin"
  description = "Confluence space admin - specific platform owner approves"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcdez"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

resource "okta_group" "app_aws_prod_readonly" {
  name        = "app-aws-prod-readonly"
  description = "AWS production read-only - manager or DevOps lead approves"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdf0"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

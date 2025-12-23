# =============================================================================
# Application Access Groups - RBAC for AI Agent
# Apps: Jira, Slack, GitHub, AWS, Confluence, PagerDuty, Datadog
# =============================================================================

# NO APPROVAL REQUIRED - Self-service access

resource "okta_group" "slack_member" {
  name        = "slack-member"
  description = "Basic Slack workspace member access"

  custom_profile_attributes = jsonencode({
    approval_type = "NONE"
  })
}

resource "okta_group" "confluence_reader" {
  name        = "confluence-reader"
  description = "Confluence read-only access"

  custom_profile_attributes = jsonencode({
    approval_type = "NONE"
  })
}

resource "okta_group" "jira_user" {
  name        = "jira-user"
  description = "Basic Jira user access for creating and viewing tickets"

  custom_profile_attributes = jsonencode({
    approval_type = "NONE"
  })
}

# MANAGER APPROVAL ONLY - Standard employee access

resource "okta_group" "github_developer" {
  name        = "github-developer"
  description = "GitHub repository read/write access for developers"

  custom_profile_attributes = jsonencode({
    approval_type = "MANAGER"
  })
}

resource "okta_group" "jira_project_admin" {
  name        = "jira-project-admin"
  description = "Jira project administrator role"

  custom_profile_attributes = jsonencode({
    approval_type = "MANAGER"
  })
}

resource "okta_group" "datadog_viewer" {
  name        = "datadog-viewer"
  description = "Datadog monitoring dashboard viewer"

  custom_profile_attributes = jsonencode({
    approval_type = "MANAGER"
  })
}

# MANUAL APPROVAL - Special cases requiring admin review

resource "okta_group" "aws_security_audit" {
  name        = "aws-security-audit"
  description = "AWS Security Audit role - requires security team review"

  custom_profile_attributes = jsonencode({
    approval_type = "MANUAL"
  })
}

# ACCOUNT_ID - ANY ONE approver (team leads, resource owners)

resource "okta_group" "slack_admin" {
  name        = "slack-admin"
  description = "Slack workspace administrator - any IT admin can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcde1", "00u1234567890abcde2", "00u1234567890abcde3"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

resource "okta_group" "confluence_admin" {
  name        = "confluence-admin"
  description = "Confluence space administrator - any platform admin can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcde1", "00u1234567890abcde2"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

resource "okta_group" "pagerduty_responder" {
  name        = "pagerduty-responder"
  description = "PagerDuty on-call responder - any SRE lead can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcde4", "00u1234567890abcde5", "00u1234567890abcde6"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

# ACCOUNT_ID - ANY TWO approvers (higher security, dual approval)

resource "okta_group" "aws_admin" {
  name        = "aws-admin"
  description = "AWS administrator access - requires two cloud architects"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcde7", "00u1234567890abcde8", "00u1234567890abcde9", "00u1234567890abcdea"]
    approval_logic        = "ANY"
    approval_threshold    = 2
  })
}

resource "okta_group" "datadog_admin" {
  name        = "datadog-admin"
  description = "Datadog admin with billing access - two SRE managers required"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcdeb", "00u1234567890abcdec", "00u1234567890abcded"]
    approval_logic        = "ANY"
    approval_threshold    = 2
  })
}

# ACCOUNT_ID - ALL approvers required (critical access)

resource "okta_group" "jira_system_admin" {
  name        = "jira-system-admin"
  description = "Jira system administrator - all platform leads must approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcdee", "00u1234567890abcdef", "00u1234567890abcdeg"]
    approval_logic        = "ALL"
    approval_threshold    = 0
  })
}

resource "okta_group" "github_org_owner" {
  name        = "github-org-owner"
  description = "GitHub organization owner - all engineering directors must approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcdeh", "00u1234567890abcdei"]
    approval_logic        = "ALL"
    approval_threshold    = 2
  })
}

# BOTH - Manager OR any account ID (flexible approval)

resource "okta_group" "aws_developer" {
  name        = "aws-developer"
  description = "AWS developer access - manager or any cloud lead can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdej", "00u1234567890abcdek", "00u1234567890abcdel"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

resource "okta_group" "jira_service_desk_agent" {
  name        = "jira-service-desk-agent"
  description = "Jira Service Desk agent - manager or any support lead can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdem", "00u1234567890abcden"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

resource "okta_group" "slack_org_admin" {
  name        = "slack-org-admin"
  description = "Slack org-level admin - manager or two IT admins can approve"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdeo", "00u1234567890abcdep", "00u1234567890abcdeq"]
    approval_logic        = "ANY"
    approval_threshold    = 2
  })
}

# BOTH - Manager AND account IDs (strict dual approval)

resource "okta_group" "aws_billing_admin" {
  name        = "aws-billing-admin"
  description = "AWS billing administrator - manager AND finance lead required"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcder"]
    approval_logic        = "ALL"
    approval_threshold    = 1
  })
}

resource "okta_group" "github_security_team" {
  name        = "github-security-team"
  description = "GitHub security team access - manager AND security lead required"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdes"]
    approval_logic        = "ALL"
    approval_threshold    = 1
  })
}

resource "okta_group" "pagerduty_admin" {
  name        = "pagerduty-admin"
  description = "PagerDuty administrator - manager AND all SRE leads required"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdet", "00u1234567890abcdeu", "00u1234567890abcdev"]
    approval_logic        = "ALL"
    approval_threshold    = 0
  })
}

resource "okta_group" "datadog_billing_admin" {
  name        = "datadog-billing-admin"
  description = "Datadog billing admin - manager AND two of three finance leads"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdew", "00u1234567890abcdex", "00u1234567890abcdey"]
    approval_logic        = "ALL"
    approval_threshold    = 2
  })
}

# Single designated approver patterns

resource "okta_group" "confluence_space_admin" {
  name        = "confluence-space-admin"
  description = "Confluence space admin - specific platform owner approves"

  custom_profile_attributes = jsonencode({
    approval_type         = "ACCOUNT_ID"
    approval_account_ids  = ["00u1234567890abcdez"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

resource "okta_group" "aws_prod_readonly" {
  name        = "aws-prod-readonly"
  description = "AWS production read-only - manager or DevOps lead approves"

  custom_profile_attributes = jsonencode({
    approval_type         = "BOTH"
    approval_account_ids  = ["00u1234567890abcdf0"]
    approval_logic        = "ANY"
    approval_threshold    = 1
  })
}

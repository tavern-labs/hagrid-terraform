# =============================================================================
# Application Access Groups - RBAC for AI Agent
# Apps: Jira, Slack, GitHub, AWS, Confluence, PagerDuty, Datadog
# Prefix: app- (distinguishes app access groups from org/security/other groups)
#
# Organizational Structure (for testing):
# - albus-dumbledore@hogwarts.com   - CEO/CTO (executive approvals)
# - minerva-mcgonagall@hogwarts.com - VP Engineering (platform/engineering)
# - severus-snape@hogwarts.com      - VP Security (security approvals)
# - arthur-weasley@hogwarts.com     - VP Operations (SRE/ops)
# - hermione-granger@hogwarts.com   - Director of Platform Engineering
# - ron-weasley@hogwarts.com        - SRE Manager
# - sirius-black@hogwarts.com       - DevOps Manager
# - remus-lupin@hogwarts.com        - Finance Manager
# =============================================================================

locals {
  okta_groups = {
    # NO APPROVAL REQUIRED - Self-service access
    app_slack_member = {
      name               = "app-slack-member"
      description        = "Basic Slack workspace member access"
      approval_type      = "NONE"
      approval_emails    = null
      approval_logic     = null
      approval_threshold = null
    }
    app_confluence_reader = {
      name               = "app-confluence-reader"
      description        = "Confluence read-only access"
      approval_type      = "NONE"
      approval_emails    = null
      approval_logic     = null
      approval_threshold = null
    }
    app_jira_user = {
      name               = "app-jira-user"
      description        = "Basic Jira user access for creating and viewing tickets"
      approval_type      = "NONE"
      approval_emails    = null
      approval_logic     = null
      approval_threshold = null
    }

    # MANAGER APPROVAL ONLY - Standard employee access
    app_github_developer = {
      name               = "app-github-developer"
      description        = "GitHub repository read/write access for developers"
      approval_type      = "MANAGER"
      approval_emails    = null
      approval_logic     = null
      approval_threshold = null
    }
    app_jira_project_admin = {
      name               = "app-jira-project-admin"
      description        = "Jira project administrator role"
      approval_type      = "MANAGER"
      approval_emails    = null
      approval_logic     = null
      approval_threshold = null
    }
    app_datadog_viewer = {
      name               = "app-datadog-viewer"
      description        = "Datadog monitoring dashboard viewer"
      approval_type      = "MANAGER"
      approval_emails    = null
      approval_logic     = null
      approval_threshold = null
    }

    # MANUAL APPROVAL - Special cases requiring admin review
    app_aws_security_audit = {
      name               = "app-aws-security-audit"
      description        = "AWS Security Audit role - requires security team review"
      approval_type      = "MANUAL"
      approval_emails    = null
      approval_logic     = null
      approval_threshold = null
    }

    # ACCOUNT_EMAIL - ANY ONE approver (team leads, resource owners)
    app_slack_admin = {
      name               = "app-slack-admin"
      description        = "Slack workspace administrator - any IT admin can approve"
      approval_type      = "ACCOUNT_EMAIL"
      approval_emails    = ["minerva-mcgonagall@hogwarts.com", "hermione-granger@hogwarts.com"]
      approval_logic     = "ANY"
      approval_threshold = 1
    }
    app_confluence_admin = {
      name               = "app-confluence-admin"
      description        = "Confluence space administrator - any platform admin can approve"
      approval_type      = "ACCOUNT_EMAIL"
      approval_emails    = ["minerva-mcgonagall@hogwarts.com", "hermione-granger@hogwarts.com"]
      approval_logic     = "ANY"
      approval_threshold = 1
    }
    app_pagerduty_responder = {
      name               = "app-pagerduty-responder"
      description        = "PagerDuty on-call responder - any SRE lead can approve"
      approval_type      = "ACCOUNT_EMAIL"
      approval_emails    = ["arthur-weasley@hogwarts.com", "ron-weasley@hogwarts.com", "sirius-black@hogwarts.com"]
      approval_logic     = "ANY"
      approval_threshold = 1
    }

    # ACCOUNT_EMAIL - ANY TWO approvers (higher security, dual approval)
    app_aws_admin = {
      name               = "app-aws-admin"
      description        = "AWS administrator access - requires two cloud architects"
      approval_type      = "ACCOUNT_EMAIL"
      approval_emails    = ["albus-dumbledore@hogwarts.com", "arthur-weasley@hogwarts.com", "sirius-black@hogwarts.com"]
      approval_logic     = "ANY"
      approval_threshold = 2
    }
    app_datadog_admin = {
      name               = "app-datadog-admin"
      description        = "Datadog admin with billing access - two SRE managers required"
      approval_type      = "ACCOUNT_EMAIL"
      approval_emails    = ["arthur-weasley@hogwarts.com", "ron-weasley@hogwarts.com", "sirius-black@hogwarts.com"]
      approval_logic     = "ANY"
      approval_threshold = 2
    }

    # ACCOUNT_EMAIL - ALL approvers required (critical access)
    app_jira_system_admin = {
      name               = "app-jira-system-admin"
      description        = "Jira system administrator - all platform leads must approve"
      approval_type      = "ACCOUNT_EMAIL"
      approval_emails    = ["minerva-mcgonagall@hogwarts.com", "hermione-granger@hogwarts.com"]
      approval_logic     = "ALL"
      approval_threshold = 0
    }
    app_github_org_owner = {
      name               = "app-github-org-owner"
      description        = "GitHub organization owner - all engineering directors must approve"
      approval_type      = "ACCOUNT_EMAIL"
      approval_emails    = ["albus-dumbledore@hogwarts.com", "minerva-mcgonagall@hogwarts.com"]
      approval_logic     = "ALL"
      approval_threshold = 2
    }

    # BOTH - Manager OR any account ID (flexible approval)
    app_aws_developer = {
      name               = "app-aws-developer"
      description        = "AWS developer access - manager or any cloud lead can approve"
      approval_type      = "BOTH"
      approval_emails    = ["arthur-weasley@hogwarts.com", "sirius-black@hogwarts.com"]
      approval_logic     = "ANY"
      approval_threshold = 1
    }
    app_jira_service_desk_agent = {
      name               = "app-jira-service-desk-agent"
      description        = "Jira Service Desk agent - manager or any support lead can approve"
      approval_type      = "BOTH"
      approval_emails    = ["hermione-granger@hogwarts.com"]
      approval_logic     = "ANY"
      approval_threshold = 1
    }
    app_slack_org_admin = {
      name               = "app-slack-org-admin"
      description        = "Slack org-level admin - manager or two IT admins can approve"
      approval_type      = "BOTH"
      approval_emails    = ["minerva-mcgonagall@hogwarts.com", "hermione-granger@hogwarts.com"]
      approval_logic     = "ANY"
      approval_threshold = 2
    }

    # BOTH - Manager AND account IDs (strict dual approval)
    app_aws_billing_admin = {
      name               = "app-aws-billing-admin"
      description        = "AWS billing administrator - manager AND finance lead required"
      approval_type      = "BOTH"
      approval_emails    = ["remus-lupin@hogwarts.com"]
      approval_logic     = "ALL"
      approval_threshold = 1
    }
    app_github_security_team = {
      name               = "app-github-security-team"
      description        = "GitHub security team access - manager AND security lead required"
      approval_type      = "BOTH"
      approval_emails    = ["severus-snape@hogwarts.com"]
      approval_logic     = "ALL"
      approval_threshold = 1
    }
    app_pagerduty_admin = {
      name               = "app-pagerduty-admin"
      description        = "PagerDuty administrator - manager AND all SRE leads required"
      approval_type      = "BOTH"
      approval_emails    = ["arthur-weasley@hogwarts.com", "ron-weasley@hogwarts.com", "sirius-black@hogwarts.com"]
      approval_logic     = "ALL"
      approval_threshold = 0
    }
    app_datadog_billing_admin = {
      name               = "app-datadog-billing-admin"
      description        = "Datadog billing admin - manager AND two of three finance leads"
      approval_type      = "BOTH"
      approval_emails    = ["albus-dumbledore@hogwarts.com", "remus-lupin@hogwarts.com"]
      approval_logic     = "ALL"
      approval_threshold = 2
    }

    # Single designated approver patterns
    app_confluence_space_admin = {
      name               = "app-confluence-space-admin"
      description        = "Confluence space admin - specific platform owner approves"
      approval_type      = "ACCOUNT_EMAIL"
      approval_emails    = ["hermione-granger@hogwarts.com"]
      approval_logic     = "ANY"
      approval_threshold = 1
    }
    app_aws_prod_readonly = {
      name               = "app-aws-prod-readonly"
      description        = "AWS production read-only - manager or DevOps lead approves"
      approval_type      = "BOTH"
      approval_emails    = ["sirius-black@hogwarts.com"]
      approval_logic     = "ANY"
      approval_threshold = 1
    }
  }
}

/*
# Create all application access groups using for_each
resource "okta_group" "app_groups" {
  for_each = local.okta_groups

  name        = each.value.name
  description = each.value.description

  # Define dependencies once for all groups
  depends_on = [
    okta_group_schema_property.approval_type,
    okta_group_schema_property.approval_emails,
    okta_group_schema_property.approval_logic,
    okta_group_schema_property.approval_threshold
  ]


  # Build custom_profile_attributes, filtering out null values
  custom_profile_attributes = jsonencode({
    for k, v in {
      approval_type      = each.value.approval_type
      approval_emails    = each.value.approval_emails
      approval_logic     = each.value.approval_logic
      approval_threshold = each.value.approval_threshold
    } : k => v if v != null
  })
}
*/

removed {
  from = okta_group.app_groups
  lifecycle {
    destroy = false # This ensures the groups STAY in Okta
  }
}





# Hagrid Terraform

Okta infrastructure-as-code for **Hagrid**, a Slack-based AI agent that automates role-based access control (RBAC) for enterprise applications.

> **Hagrid** (_"Keeper of Keys"_ - a Harry Potter reference) converses with users in Slack to grant application access based on flexible approval workflows defined in Okta groups.

## What This Repo Contains

This Terraform configuration defines:
- **Custom Okta group schema** for flexible approval workflows
- **Example application access groups** demonstrating all approval scenarios
- Groups for Jira, Slack, GitHub, AWS, Confluence, PagerDuty, and Datadog

## Schema Design

Four custom attributes enable flexible approval logic:

| Attribute | Type | Description |
|-----------|------|-------------|
| `approval_type` | enum | Who must approve: `NONE`, `MANAGER`, `ACCOUNT_ID`, `BOTH`, `MANUAL` |
| `approval_account_ids` | array | List of Okta user IDs authorized to approve |
| `approval_logic` | enum | `ALL` (AND conditions) or `ANY` (OR conditions) |
| `approval_threshold` | integer | Number of approvals required (0 with ALL = require all) |

## Approval Scenarios

The `groups.tf` file demonstrates all possible approval patterns:

- **Self-service** - No approval required (e.g., `app-slack-member`)
- **Manager only** - Direct manager approval (e.g., `app-github-developer`)
- **Designated approvers** - Any one, two, or N specific approvers (e.g., `app-slack-admin`)
- **Unanimous approval** - All designated approvers required (e.g., `app-jira-system-admin`)
- **Flexible OR logic** - Manager OR any account ID (e.g., `app-aws-developer`)
- **Strict AND logic** - Manager AND account IDs (e.g., `app-aws-billing-admin`)
- **Manual review** - Admin-only approval outside automated flows

## Group Naming Convention

All application access groups use the `app-` prefix (e.g., `app-jira-user`, `app-aws-admin`) to distinguish them from organizational, security, or other group types.

## Infrastructure Setup

**State Management:** S3 backend with encryption and state locking for secure, collaborative infrastructure management.

**Okta Authentication:** OAuth 2.0 credential exchange using an Okta application configured with:
- `okta.groups.manage` scope - Create and manage Okta groups
- `okta.schemas.manage` scope - Define custom group attributes
- Admin privileges for group schema modifications

This approach uses service account credentials instead of personal API tokens for production-grade security.

## Files

- `schema.tf` - Okta group schema definitions with custom attributes
- `groups.tf` - Example groups covering all approval scenarios
- `providers.tf` - Okta provider configuration
- `backend.tf` - Terraform state backend configuration
- `variables.tf` - Terraform variables

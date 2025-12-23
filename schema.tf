# Create the metadata field for who must approve
resource "okta_group_schema_property" "approval_type" {
  index       = "approval_type"
  title       = "Approval Type"
  type        = "string"
  description = "The required approval flow for this group"
  master      = "OKTA"
  scope       = "SELF"

  enum = ["MANAGER", "ACCOUNT_ID", "BOTH", "MANUAL", "NONE"]

  # This provides the "Human Readable" labels for the Okta UI
  one_of {
    const = "MANAGER"
    title = "Manager Approval Only"
  }
  one_of {
    const = "ACCOUNT_ID"
    title = "Specific Account IDs"
  }
  one_of {
    const = "BOTH"
    title = "Manager AND Account ID"
  }
  one_of {
    const = "MANUAL"
    title = "Manual Approval Only Required"
  }
  one_of {
    const = "NONE"
    title = "No Approval Required"
  }
}

# Account IDs that can approve
resource "okta_group_schema_property" "approval_account_ids" {
  index       = "approval_account_ids"
  title       = "Approval Account IDs"
  type        = "array"       
  array_type  = "string"      
  description = "List of Okta User IDs authorized to approve for this group"
}

# One approver or all approvers
resource "okta_group_schema_property" "approval_logic" {
  index       = "approval_logic"
  title       = "Approval Logic"
  type        = "string"
  enum        = ["ALL", "ANY"]
  description = "One of many approvers or all approvers (e.g., Manager and all IDs, or Manager OR One of IDs, all of IDs, one of IDs"

  one_of {
    const = "ALL"
    title = "All Conditions Must Be Met"
  }
    one_of {
    const = "ANY"
    title = "Any Condition Can Be Met"
  }
}

# How many approvals are required
resource "okta_group_schema_property" "approval_threshold" {
  index       = "approval_threshold"
  title       = "Approval Threshold"
  type        = "integer"
  description = "Number of approvals needed. If 0 and logic is ALL, it defaults to the full count of the ID list."
}
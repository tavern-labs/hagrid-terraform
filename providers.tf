provider "okta" {
  org_name    = var.okta_org_name
  base_url    = var.okta_base_url
  client_id   = var.okta_client_id
  scopes = [
    "okta.users.manage",
    "okta.users.read",
    "okta.groups.manage",
    "okta.groups.read",
    "okta.apps.manage",
    "okta.apps.read",
    "okta.schemas.manage",
    "okta.schemas.read",  
    "okta.policies.manage",
    "okta.policies.read",
    "okta.idps.read"      
  ]
  private_key = var.okta_private_key
}
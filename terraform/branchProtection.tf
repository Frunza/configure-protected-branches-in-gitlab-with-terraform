// Docmentation: https://docs.gitlab.com/ee/user/project/protected_branches.html

resource "gitlab_branch_protection" "restrictAll" {
  for_each                     = var.repositoryIDs
  project                      = each.value
  branch                       = "*"
  push_access_level            = "no one"
  merge_access_level           = "no one"
  allow_force_push             = false
}

resource "gitlab_branch_protection" "allowFeatures" {
  for_each                     = var.repositoryIDs
  project                      = each.value
  branch                       = "feature/*"
  push_access_level            = "developer"
  merge_access_level           = "developer"
  allow_force_push             = false
}

resource "gitlab_branch_protection" "allowBugs" {
  for_each                     = var.repositoryIDs
  project                      = each.value
  branch                       = "bug/*"
  push_access_level            = "developer"
  merge_access_level           = "developer"
  allow_force_push             = false
}

resource "gitlab_branch_protection" "allowExtendedBugs" {
  for_each                     = var.repositoryIDs
  project                      = each.value
  branch                       = "bug/*/*"
  push_access_level            = "developer"
  merge_access_level           = "developer"
  allow_force_push             = false
}

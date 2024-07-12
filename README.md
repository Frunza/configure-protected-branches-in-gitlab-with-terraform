# Configure protected branches in GitLab with Terraform

## Scenario

If you are using `GitLab` and `Terraform`, how can you configure the protected branches of a `GitLab` repository with the help of `Terraform`?

I assume that you already know how to create a `Terraform` project for `GitLab` and run `Terraform` inside a container. Take a look at [Configure Docker container with Terraform](https://github.com/Frunza/configure-docker-container-with-terraform) otherwise.

## Prerequisites

A Linux or MacOS machine for local development. If you are running Windows, you first need to set up the *Windows Subsystem for Linux (WSL)* environment.

You need `docker cli` and `docker-compose` on your machine for testing purposes, and/or on the machines that run your pipeline.
You can check both of these by running the following commands:
```sh
docker --version
docker-compose --version
```

One or more `GitLab` repositories for testing purposes.

## Implementation

Let's say that you want to allow branches that start with *feature* or *bug* and are followed by some text, which is free to choose. In `GitLab`, the way you want to do this is to reject everything and add the patterns you want to allow.

To reject everything, you can use the following code snippet:
```sh
resource "gitlab_branch_protection" "restrictAll" {
  for_each                     = var.repositoryIDs
  project                      = each.value
  branch                       = "*"
  push_access_level            = "no one"
  merge_access_level           = "no one"
  allow_force_push             = false
}
```

To allow *feature* and *bug*:
```sh
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
```

`GitLab` allows more complex patterns as well, but they are not as powerful as regex. For example, if you want to allow two sections for bugs, so that *bug/id/test1* is allowed, you can do it as shown below:
```sh
resource "gitlab_branch_protection" "allowExtendedBugs" {
  for_each                     = var.repositoryIDs
  project                      = each.value
  branch                       = "bug/*/*"
  push_access_level            = "developer"
  merge_access_level           = "developer"
  allow_force_push             = false
}
```

More information about protected branches in `GitLab` can be found [here](https://docs.gitlab.com/ee/user/project/protected_branches.html). You can find there some other patterns examples as well.

Do note that the code snippets apply these rules for more repositories. This is done using variables that hold the IDs of each repository:
```sh
repositoryIDs = [
    "123", // repository demo1
    "456", // repository demo2
    ]
```

To find out the ID of a `GitLab` repository, navigate to the *settings* of the repository and choose the *general* section.

## Usage

Navigate to the root of the git repository and run the following command:
```sh
sh run.sh 
```

The following happens:
1) the first command builds the docker image and tags it as *gitlabterraformcontainer*
2) the docker image copies the `Terraform` project to an appropriate location.
3) the second command uses docker-compose to create and run the container. The container runs
```sh
terraform init && terraform validate && terraform apply -auto-approve
```

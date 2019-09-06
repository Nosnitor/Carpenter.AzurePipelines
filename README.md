[Nosnitor](https://rcsit.com)

# Introduction

The Carpenter.AzurePipelines project provides common YAML templates and scripts for Azure
Pipelines definitions.

## Features
Carpenter.AzurePipelines provides the following functionality:

### Build Versioning

By including a VERSION file in the source of the project, consistent versioning is applied to the
build and any binaries or packages generated as output.

| Build type | Version example | Description
|:--|:--|:--|
| Continuous Integration | 1.2.3-CI.20190906.42 | The 42nd CI build on September 6, 2019 for version 1.2.3.


# Usage

## Integrating Carpenter.AzurePipelines

Due to the way that pipeline templates are sourced by Azure Pipelines, the templates and 
supporting files are accessed using different methods.

### Template integration

Azure DevOps Pipelines templates are integrated into your build process by using the resources specification.

```YAML
# Repo: Your projects repository
# File: azure-pipelines.yml
resources:
  repositories:
  - repository: carpenterAzurePipelines
    type: github
    name: Nosnitor/Carpenter.AzurePipelines
    endpoint: Nosnitor

jobs:
- template: templates/pipeline-jobs.yml@carpenterAzurePipelines
  parameters:
    solutionName: '$(Carpenter.SolutionName)'
    sonarQubeProjectKey: '$(Carpenter.SonarQube.ProjectKey)'
    versionFile: '$(Carpenter.Version.VersionFile)'

```
[Nosnitor](https://rcsit.com)

[![Build Status](https://dev.azure.com/nosnitor/Carpenter/_apis/build/status/Nosnitor.Carpenter.AzurePipelines?branchName=master)](https://dev.azure.com/nosnitor/Carpenter/_build/latest?definitionId=61&branchName=master)

# Introduction

The Carpenter.AzurePipelines project provides common YAML templates and scripts for Azure
Pipelines definitions.

## Features
Carpenter.AzurePipelines provides the following functionality:

### Build Versioning

By including a `VERSION` file in the source of the project, consistent versioning is applied to the
build and any binaries or packages generated as output.

| Build type | Version example | Description
|:--|:--|:--|
| Continuous Integration | 1.2.3-CI.20190906.42 | The 42nd CI build on September 6, 2019 for version 1.2.3.


# Usage

## Integrating Carpenter.AzurePipelines

Due to the way that pipeline templates are evaluated by Azure Pipelines, the templates and 
supporting files are accessed using different methods.

### Template integration

Azure DevOps Pipelines templates are integrated into the build process by using the
`resources` specification.

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
- template: templates/stage/carpenter-default.yml@carpenterAzurePipelines
  parameters:
    solutionName: 'Acme.MySolution'
    sonarQubeProjectKey: 'MySolution'
    versionFile: 'VERSION'
```

### Script and supporting files integration

The scripts and supporting files used by the templates can be integrated with the
project using a git submodule. The submodule should be located at
```[projectRoot]/build/Carpenter.AzurePipelines```.

```
pwd
# /the/project/directory

mkdir build
cd build
git submodule add -b master https://github.com/Nosnitor/Carpenter.AzurePipelines
cd ..
```

You can update the submodule using:
```
git submodule update --remote
```
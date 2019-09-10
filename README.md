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

### Display Build Variables

By referencing the ```display-variables.yml``` template, Azure DevOps variables can be
displayed as part of a job. Carpenter specific variables are also displayed.

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


stages:
- template: templates/stage/carpenter-default.yml@carpenterAzurePipelines
  parameters:
    solutionName: 'Acme.MySolution'
    solutionPath: 'Acme.MySolution.sln' # Solution is in the same folder as azure-pipelines.yml
    sonarQubeProjectKey: 'MySolution'
    versionFile: 'VERSION'
    vmImage: ubuntu-latest
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

## Variables

The following variables are used:

| Variable Name | Env Variable Name | Parameter Name | Default Value | Description |
|:--|:--|:--|:--|:--|
| Carpenter.Build.Enabled | CARPENTER_BUILD_ENABLED | buildEnabled | true, if solution exists | Should the build, test and analyze job be exectued?
| Carpenter.Build.VMImage | CARPENTER_BUILD_VMIMAGE | vmImage | ubuntu-latest | The VM Image to use for build steps. |
| Carpenter.SolutionName | CARPENTER_SOLUTIONNAME | solutionName | $(Build.DefinitionName) | The name of the solution. |
| Carpenter.SolutionPath | CARPENTER_SOLUTIONPATH | solutionPath | $(Carpenter.SolutionName).sln | The path to the solution file. |
| Carpenter.SonarCloud.Enabled | CARPENTER_SONARCLOUD_ENABLED | sonarCloudEnabled | true if other values present | Are SonarCloud steps enabled for the build, test, and analyze job?
| Carpenter.SonarCloud.Organization | CARPENTER_SONARCLOUD_ORGANIZATION | sonarCloudOrganization | | The SonarCloud Organization that the project is under. |
| Carpenter.SonarCloud.ProjectKey | CARPENTER_SONARCLOUD_PROJECTKEY | sonarCloudProjectKey | | The SonarCloud project key used by the project. |
| Carpenter.SonarCloud.ServiceConnection | CARPENTER_SONARCLOUD_SERVICECONNECTION | sonarCloudServiceConnection | | The Azure DevOps SonarCloud service connection. |
| Carpenter.Version.VerisonFile | CARPENTER_VERSION_VERSIONFILE | versionFile | VERSION file in project root| The VERSION file to use for project versioning. |
| Carpenter.Version.Major | CARPENTER_VERSION_MAJOR | | | The major portion of the SemVer build version. |
| Carpenter.Version.Minor | CARPENTER_VERSION_MINOR | | | The minor portion of the SemVer build version. |
| Carpenter.Version.Patch | CARPENTER_VERSION_PATCH | | | The patch portion of the SemVer build version. |
| Carpenter.Version.Prefix | CARPENTER_VERSION_PREFIX | | {major}.{minor}.{patch} | The prefix portion of the SemVer build version. |
| Carpenter.Version.Suffix | CARPENTER_VERSION_SUFFIX | | | The suffix portion of the SemVer build version. |
| Carpenter.Version.PackageVersion | CARPENTER_VERSION_PACKAGEVERSION | | | The SemVer build version applied to packages. |
# MIT License

# Copyright (c) 2021 Filip Liwiński

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

function Add-VariableGroup {
    param(
        [string] $projectName,
        [AzureDevOpsServicesAPIClient] $apiClient,
        [PSObject] $variableGroup
    )

    return $apiClient.AddVariableGroup($projectName, $variableGroup)
}

function Copy-VariableGroup {
    param(
        [string] $projectName,
        [AzureDevOpsServicesAPIClient] $apiClient,
        [int] $sourceVariableGroupId
    )

    $sourceVariableGroup = $apiClient.GetVariableGroupById($projectName, $sourceVariableGroupId)

    $newVariableGroup = @{
        "description" = $sourceVariableGroup.description
        "name" = "$($sourceVariableGroup.name) - copy"
        "providerData" = $sourceVariableGroup.providerData
        "type" = $sourceVariableGroup.type
        "variableGroupProjectReferences" = $sourceVariableGroup.variableGroupProjectReferences
        "variables" = $sourceVariableGroup.variables
    }

    return $apiClient.AddVariableGroup($projectName, $newVariableGroup)
}

function Get-VariableGroup {
    param (
        [string] $projectName,
        [string] $outputPath = '',
        [AzureDevOpsServicesAPIClient] $apiClient,
        [int] $variableGroupId
    )

    $variableGroup = $apiClient.GetVariableGroupById($projectName, $variableGroupId)
    return $variableGroup
}

function Get-VariableGroupByName {
    param (
        [string] $projectName,
        [AzureDevOpsServicesAPIClient] $apiClient,
        [string] $variableGroupName
    )

    $variableGroup = $apiClient.GetVariableGroupByName($projectName, $variableGroupName)
    return $variableGroup
}

function Export-VariableGroup {
    param (
        [string] $projectName,
        [string] $outputPath = '',
        [AzureDevOpsServicesAPIClient] $apiClient,
        [int] $variableGroupId
    )

    if ($null -eq $outputPath -or '' -eq $outputPath) {
        $outputPath = "."
    }

    $variableGroup = $apiClient.GetVariableGroupById($projectName, $variableGroupId)

    if ($null -ne $variableGroup) {
        New-Item -ItemType Directory -Force -Path $outputPath | Out-Null
    }

    $name = $variableGroup.name
    ConvertTo-Json $variableGroup -Depth 100 > "$outputPath\$name.json"
}

function Export-VariableGroups {
    param (
        [string] $projectName,
        [string] $outputPath = '',
        [AzureDevOpsServicesAPIClient] $apiClient
    )

    if ($null -eq $outputPath -or '' -eq $outputPath) {
        $outputPath = "."
    }

    $variableGroups = $apiClient.GetVariableGroups($projectName)

    if ($null -ne $variableGroups) {
        New-Item -ItemType Directory -Force -Path $outputPath | Out-Null
    }

    foreach ($variableGroup in $variableGroups) {
        ConvertTo-Json $variableGroup -Depth 100 > "$outputPath\$($variableGroup.name).json"
    }
}

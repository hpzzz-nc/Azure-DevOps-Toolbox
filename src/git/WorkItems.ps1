$workItemApiClient = [WorkItemTrackingOnpremApiClient]::new($tfsServiceHost, $organization, $projectName, $patToken,
                                    $targetTfsServiceHost, $targetOrganization, $targetProjectName, $targetPatToken)
function Add-PullRequest-To-WorkItem {
    param(
        [bool] $useTargetProject,
        [string] $workItemId,
        [psobject] $body
    )
    $workItemApiClient.UpdateWorkItem($useTargetProject, $body, $workItemId, $true)
}
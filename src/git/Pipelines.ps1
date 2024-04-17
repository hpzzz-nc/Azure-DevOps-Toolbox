$pipelinesApiClient = [PipelinesOnpremApiClient]::new($tfsServiceHost, $organization, $projectName, $patToken,
                                    $targetTfsServiceHost, $targetOrganization, $targetProjectName, $targetPatToken)
                                

$policyApiClient = [PolicyOnpremApiClient]::new($tfsServiceHost, $organization, $projectName, $patToken,
                                    $targetTfsServiceHost, $targetOrganization, $targetProjectName, $targetPatToken)
function Create-Pipeline {
    param (
        [bool] $useTargetProject,
        [psobject] $body
    )
    $pipelinesApiClient.CreatePipeline($useTargetProject, $body)
}

function Get-Pipelines {
    param (
        [bool] $useTargetProject
    )

    return $pipelinesApiClient.ListPipelines($useTargetProject).value
}
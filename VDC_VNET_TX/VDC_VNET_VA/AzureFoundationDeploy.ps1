<#
 .SYNOPSIS
    Deploys a template to Azure

 .DESCRIPTION
    Deploys an Azure Resource Manager template

 .PARAMETER subscriptionId
    The subscription id where the template will be deployed.

 .PARAMETER resourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER resourceGroupLocation
    Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.

 .PARAMETER deploymentName
    The deployment name.

 .PARAMETER templateFilePath
    Optional, path to the template file. Defaults to template.json.

 .PARAMETER parametersFilePath
    Optional, path to the parameters file. Defaults to parameters.json. If file is not found, will prompt for parameter values based on template.
#>

param(
 [Parameter(Mandatory=$True)]
 [string]
 $subscriptionId,

 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupName,

 [string]
 $resourceGroupLocation,

 [Parameter(Mandatory=$True)]
 [string]
 $deploymentName,

 [string]
 $templateFilePath = "template.json",

 [string]
 $parametersFilePath = "parameters.json"
)

<#
.SYNOPSIS
    Registers RPs
#>
Function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Host "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzureRmResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

# sign in
Write-Host "Logging in...";
Login-AzureRmAccount -EnvironmentName $Environment;
$resourceGroupLocation = 'usgovvirginia'
$location="usgovvirginia"

# select subscription
#Write-Host "Selecting subscription '$subscriptionId'";
$subscriptionId=$SubID_Services
Select-AzureRmSubscription -SubscriptionID $subscriptionId;
$resourceGroupName="vdc_vnet_va"
# Register RPs
$resourceProviders = @("microsoft.compute","microsoft.network");
if($resourceProviders.length) {
    Write-Host "Registering resource providers"
    foreach($resourceProvider in $resourceProviders) {
        RegisterRP($resourceProvider);
    }
}

#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
    if(!$Location) {
        $Location = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$resourceGroupName' in location '$Location'";
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $Location
}
else{
    Write-Host "Using existing resource group '$resourceGroupName'";
}
<#
This section is where we build the NSG for the VNET
#>
$parametersFilePath='https://raw.githubusercontent.com/willstg/VDC/master/VDC_VNET_TX/VDC_VNET_TX/azuredeploy.parameters.json'
$templateFilePath='https://raw.githubusercontent.com/willstg/VDC/master/VDC_VNET_TX/VDC_VNET_TX/azuredeploy.json'
$localparametersFilePath="C:\Users\WILLS\Source\Repos\VDC\VDC_VNET_TX\VDC_VNET_TX\azuredeploy.parameters.json"
$localtemplateFilePath="C:\Users\WILLS\Source\Repos\VDC\VDC_VNET_TX\VDC_VNET_TX\azuredeploy.json"


# Start the deployment
Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourcegroupname -TemplateFile $localtemplateFilePath -TemplateParameterFile $localTemplateFilePath;


Write-Host "Starting deployment...";
if(Test-Path $parametersFilePath) {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateURI $templateFilePath -TemplateParameterUri $parametersFilePath;
} else {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateURI $templateFilePath -TemplateParameterUri $parametersFilePath;
}
Write-Host "Starting deployment...";
if(Test-Path $parametersFilePath1) {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Templatefile $localtemplateFilePath -TemplateParameterfile $localparametersFilePath;
} else {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateURI $localtemplateFilePath ;
}


<#
This section is where we build the UDR for the VNET
#>
$parametersFilePath1="https://raw.githubusercontent.com/willstg/VDC/master/VDC_VNET_TX/VDC_VNET_TX/azuredeploy_VNET_UDR_3of4.parameters.json"
$templateFilePath1="https://raw.githubusercontent.com/willstg/VDC/master/VDC_VNET_TX/VDC_VNET_TX/azuredeploy_VNET_UDR_3of4.json"
$localparametersFilePath1="C:\Users\WILLS\Source\Repos\VDC\VDC_VNET_TX\VDC_VNET_TX\azuredeploy_VNET_UDR_3of4.parameters.json"
$localtemplateFilePath1="C:\Users\WILLS\Source\Repos\VDC\VDC_VNET_TX\VDC_VNET_TX\azuredeploy_VNET_UDR_3of4.json"


Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourcegroupname -TemplateFile $localtemplateFilePath1 
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateParameterFile
# Start the deployment
Write-Host "Starting deployment...";
if(Test-Path $parametersFilePath1) {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateURI $templateFilePath1 -TemplateParameterURI $parametersFilePath1;
} else {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateURI $templateFilePath1;
}
Write-Host "Starting deployment...";
if(Test-Path $parametersFilePath1) {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Templatefile $localtemplateFilePath -TemplateParameterfile $localparametersFilePath;
} else {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateURI $templateFilePath1;
}

<#
This section is where we build the VNET for the VNET
#>
$parametersFilePath2='https://raw.githubusercontent.com/willstg/VDC/master/VDC_VNET_TX/VDC_VNET_TX/azuredeploy_VNET_3of4.parameters.json'
$templateFilePath2='https://raw.githubusercontent.com/willstg/VDC/master/VDC_VNET_TX/VDC_VNET_TX/azuredeploy_VNET_3of4.json'
# Start the deployment
Write-Host "Starting deployment...";
if(Test-Path $parametersFilePath2) {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath2 -TemplateParameterFile $parametersFilePath2;
} else {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;
}


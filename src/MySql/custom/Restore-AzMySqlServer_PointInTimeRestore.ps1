
# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

function Restore-AzMySqlServer_PointInTimeRestore {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.MySql.Models.Api20171201.IServer])]
    [CmdletBinding(PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    [Microsoft.Azure.PowerShell.Cmdlets.MySql.Description('Restore a server from an existing backup')]
    param(
        [Parameter(Mandatory, HelpMessage = 'The name of the server.')]
        [Alias('ServerName')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Path')]
        [System.String]
        ${Name},

        [Parameter(Mandatory, HelpMessage = 'The name of the resource group that contains the resource, You can obtain this value from the Azure Resource Manager API or the portal.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Path')]
        [System.String]
        ${ResourceGroupName},

        [Parameter(Mandatory, HelpMessage = 'The location the resource resides in.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [System.DateTime]
        ${RestorePointInTime},

        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'The source server object to restore from.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Models.Api20171201.IServer]
        ${InputObject},

        [Parameter(HelpMessage = 'The location the resource resides in.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [System.String]
        ${Location},

        [Parameter(HelpMessage = 'The name of the sku, typically, tier + family + cores, e.g. B_Gen4_1, GP_Gen5_8.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [System.String]
        ${Sku},

        [Parameter(HelpMessage = 'Application-specific metadata in the form of key-value pairs.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.MySql.Models.Api20171201.IServerForCreateTags]))]
        [System.Collections.Hashtable]
        ${Tag},

        [Parameter(Mandatory, HelpMessage = 'Use PointInTime mode to restore')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        ${UsePointInTimeRestore},

        [Parameter(HelpMessage = 'The credentials, account, tenant, and subscription used for communication with Azure.')]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Azure')]
        [System.Management.Automation.PSObject]
        ${DefaultProfile},

        [Parameter(HelpMessage = 'Run the command as a job.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        ${AsJob},

        [Parameter(DontShow, HelpMessage = 'Wait for .NET debugger to attach.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        ${Break},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline.
        ${HttpPipelineAppend},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline.
        ${HttpPipelinePrepend},

        [Parameter(HelpMessage = 'Run the command asynchronously.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        ${NoWait},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use.
        ${Proxy},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call.
        ${ProxyCredential},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy.
        ${ProxyUseDefaultCredentials}
    )   

    process {
        try {
          $Parameter = [Microsoft.Azure.PowerShell.Cmdlets.MySql.Models.Api20171201.ServerForCreate]::new()

          $Parameter.Property = [Microsoft.Azure.PowerShell.Cmdlets.MySql.Models.Api20171201.ServerPropertiesForRestore]::new()
          $Parameter.Property.RestorePointInTime = $PSBoundParameters['RestorePointInTime']
          $null = $PSBoundParameters.Remove('RestorePointInTime')
          $null = $PSBoundParameters.Remove('UsePointInTimeRestore')
          $Parameter.CreateMode = [Microsoft.Azure.PowerShell.Cmdlets.MySql.Support.CreateMode]::PointInTimeRestore

          $server = $PSBoundParameters['InputObject']
          $Parameter.Property.SourceServerId = $server.Id
          $Parameter.Location = $server.Location
          $null = $PSBoundParameters.Remove('InputObject')

          if ($PSBoundParameters.ContainsKey('Location')) {
              $Parameter.Location = $PSBoundParameters['Location']
              $null = $PSBoundParameters.Remove('Location')
          }

          if ($PSBoundParameters.ContainsKey('Sku')) {
              $Parameter.SkuName = $PSBoundParameters['Sku']
              $null = $PSBoundParameters.Remove('Sku')
          }

          if ($PSBoundParameters.ContainsKey('Tag')) {
              $Parameter.Tag = $PSBoundParameters['Tag']
              $null = $PSBoundParameters.Remove('Tag')
          }

          $PSBoundParameters.Add('Parameter', $Parameter)

          Az.MySql.internal\New-AzMySqlServer @PSBoundParameters
        } catch {
            throw
        }
    }
}



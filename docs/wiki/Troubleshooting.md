Having trouble using the module and unable to find a solution in the Wiki?

If it isn't listed below, let us know about it in our [Issues][Issues] log. We'll do our best to help and you may find your issue documented here in the future!

[Issues]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues "Terraform Module for Cloud Adoption Framework Enterprise-scale: Report an Issue"

#### Errors creating Role Definitions and Role Assignments

<details>
  <summary><samp>Error: authorization.RoleDefinitionsClient#Get: Failure responding to request: StatusCode=404 -- Original Error: autorest/azure: Service returned an error. Status=404 Code="RoleDefinitionDoesNotExist" Message="The specified role definition with ID '&#60;redacted&#62;' does not exist."
</samp></summary>
  <dl>
    <dd><strong>Description:</strong></dd>
    <dd>
      <p>This error is a transient error which may occur when the Resource Provider in ARM is yet to complete replication of the newly created Role Definition.</p>
    </dd>
    <dd><strong>Solution:</strong></dd>
    <dd>
      <p>If the Role Definition has been successfully created in Azure but has not been committed to the <code>terraform state</code> you will need to run <code>terraform import</code> to add the Resource to the state file. Due to caching in ARM, it could take up to 10 minutes before you can successfully import the Resource.</p>
      <p>This problem has been identified and logged on GitHub against the AzureRM Provider: <a href="https://github.com/terraform-providers/terraform-provider-azurerm/issues/10442">#10442</a></p>
    </dd>
  </dl>
</details>

<details>
  <summary><samp>Error: authorization.RoleAssignmentsClient#Get: Failure responding to request: StatusCode=404 -- Original Error: autorest/azure: Service returned an error. Status=404 Code="RoleAssignmentNotFound" Message="The role assignment '&#60;redacted&#62;' is not found."</samp></summary>
  <dl>
    <dd><h5>Description:</h5></dd>
    <dd>Coming soon</dd>
  </dl>
</details>

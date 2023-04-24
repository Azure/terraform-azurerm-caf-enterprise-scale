<!-- markdownlint-disable first-line-h1 -->
![Azure logo](media/azure.svg)

## Azure landing zones Terraform module

- [Home][wiki_home]
- [User guide][wiki_user_guide]
  - [Getting started][wiki_getting_started]
  - [Module outputs][wiki_module_outputs]
  - [Module permissions][wiki_module_permissions]
  - [Module variables][wiki_module_variables]
  - [Module releases][wiki_module_releases]
  - [Module upgrade guidance][wiki_module_upgrade_guidance]
  - [Provider configuration][wiki_provider_configuration]
  - [Archetype definitions][wiki_archetype_definitions]
  - [Core resources][wiki_core_resources]
  - [Management resources][wiki_management_resources]
  - [Connectivity resources][wiki_connectivity_resources]
  - [Identity resources][wiki_identity_resources]
- [Video guides][wiki_video_guides]
- [Examples][wiki_examples]
  - [Level 100][wiki_examples_level_100]
    - [Deploy default configuration][wiki_deploy_default_configuration]
    - [Deploy demo landing zone archetypes][wiki_deploy_demo_landing_zone_archetypes]
  - [Level 200][wiki_examples_level_200]
    - [Deploy custom Landing Zone Archetypes][wiki_deploy_custom_landing_zone_archetypes]
    - [Deploy connectivity resources (Hub and Spoke)][wiki_deploy_connectivity_resources]
    - [Deploy connectivity resources (Virtual WAN)][wiki_deploy_virtual_wan_resources]
    - [Deploy identity resources][wiki_deploy_identity_resources]
    - [Deploy management resources][wiki_deploy_management_resources]
    - [Assign a built-in policy][wiki_assign_a_built_in_policy]
    - [Create and assign custom RBAC roles][wiki_create_and_assign_custom_rbac_roles]
    - [Set parameter values for Policy Assignments][wiki_set_parameter_values_for_policy_assignments]
  - [Level 300][wiki_examples_level_300]
    - [Deploy connectivity resources with custom settings (Hub and Spoke)][wiki_deploy_connectivity_resources_custom]
    - [Deploy connectivity resources with custom settings (Virtual WAN)][wiki_deploy_virtual_wan_resources_custom]
    - [Deploy identity resources with custom settings][wiki_deploy_identity_resources_custom]
    - [Deploy management resources with custom settings][wiki_deploy_management_resources_custom]
    - [Expand built-in archetype definitions][wiki_expand_built_in_archetype_definitions]
    - [Create custom policies, initiatives and assignments][wiki_create_custom_policies_policy_sets_and_assignments]
    - [Override module role assignments][wiki_override_module_role_assignments]
    - [Control policy enforcement mode]([Examples]-Deploy-policies-without-enforcing-them)
  - [Level 400][wiki_examples_level_400]
    - [Deploy using module nesting][wiki_deploy_using_module_nesting]
    - [Deploy using multiple module declarations with orchestration][wiki_deploy_using_multiple_module_declarations_with_orchestration]
    - [Deploy using multiple module declarations with remote state][wiki_deploy_using_multiple_module_declarations_with_remote_state]
- [Frequently Asked Questions][wiki_frequently_asked_questions]
- [Troubleshooting][wiki_troubleshooting]
- [Contributing][wiki_contributing]
  - [Raising an issue][wiki_raising_an_issue]
  - [Feature requests][wiki_feature_requests]
  - [Contributing to code][wiki_contributing_to_code]
  - [Contributing to documentation][wiki_contributing_to_documentation]

[//]: # "************************"
[//]: # "INSERT LINK LABELS BELOW"
[//]: # "************************"

[wiki_home]:                                                         Home "Wiki - Home"
[wiki_user_guide]:                                                   User-Guide "Wiki - User guide"
[wiki_getting_started]:                                              %5BUser-Guide%5D-Getting-Started "Wiki - Getting started"
[wiki_module_outputs]:                                               %5BUser-Guide%5D-Module-Outputs "Wiki - Module outputs"
[wiki_module_permissions]:                                           %5BUser-Guide%5D-Module-Permissions "Wiki - Module permissions"
[wiki_module_variables]:                                             %5BUser-Guide%5D-Module-Variables "Wiki - Module variables"
[wiki_module_releases]:                                              %5BUser-Guide%5D-Module-Releases "Wiki - Module releases"
[wiki_module_upgrade_guidance]:                                      %5BUser-Guide%5D-Module-upgrade-guidance "Wiki - Module upgrade guidance"
[wiki_provider_configuration]:                                       %5BUser-Guide%5D-Provider-Configuration "Wiki - Provider configuration"
[wiki_archetype_definitions]:                                        %5BUser-Guide%5D-Archetype-Definitions "Wiki - Archetype definitions"
[wiki_core_resources]:                                               %5BUser-Guide%5D-Core-Resources "Wiki - Core resources"
[wiki_management_resources]:                                         %5BUser-Guide%5D-Management-Resources "Wiki - Management resources"
[wiki_connectivity_resources]:                                       %5BUser-Guide%5D-Connectivity-Resources "Wiki - Connectivity resources"
[wiki_identity_resources]:                                           %5BUser-Guide%5D-Identity-Resources "Wiki - Identity resources"
[wiki_video_guides]:                                                 Video-guides "Wiki - Video guides"
[wiki_examples]:                                                     Examples "Wiki - Examples"
[wiki_examples_level_100]:                                           Examples#basic-level-100 "Wiki - Examples - Basic (Level 100)"
[wiki_examples_level_200]:                                           Examples#intermediate-level-200 "Wiki - Examples - Intermediate (Level 200)"
[wiki_examples_level_300]:                                           Examples#advanced-level-300 "Wiki - Examples - Advanced (Level 300)"
[wiki_examples_level_400]:                                           Examples#advanced-level-400 "Wiki - Examples - Expert (Level 400)"
[wiki_deploy_default_configuration]:                                 %5BExamples%5D-Deploy-Default-Configuration "Wiki - Deploy default configuration"
[wiki_deploy_demo_landing_zone_archetypes]:                          %5BExamples%5D-Deploy-Demo-Landing-Zone-Archetypes "Wiki - Deploy demo landing zone archetypes"
[wiki_deploy_custom_landing_zone_archetypes]:                        %5BExamples%5D-Deploy-Custom-Landing-Zone-Archetypes "Wiki - Deploy custom landing zone archetypes"
[wiki_deploy_management_resources]:                                  %5BExamples%5D-Deploy-Management-Resources "Wiki - Deploy management resources"
[wiki_deploy_management_resources_custom]:                           %5BExamples%5D-Deploy-Management-Resources-With-Custom-Settings "Wiki - Deploy management resources with custom settings"
[wiki_deploy_connectivity_resources]:                                %5BExamples%5D-Deploy-Connectivity-Resources "Wiki - Deploy connectivity resources (Hub and Spoke)"
[wiki_deploy_connectivity_resources_custom]:                         %5BExamples%5D-Deploy-Connectivity-Resources-With-Custom-Settings "Wiki - Deploy connectivity resources with custom settings (Hub and Spoke)"
[wiki_deploy_virtual_wan_resources]:                                 %5BExamples%5D-Deploy-Virtual-WAN-Resources "Wiki - Deploy connectivity resources (Virtual WAN)"
[wiki_deploy_virtual_wan_resources_custom]:                          %5BExamples%5D-Deploy-Virtual-WAN-Resources-With-Custom-Settings "Wiki - Deploy connectivity resources with custom settings (Virtual WAN)"
[wiki_deploy_identity_resources]:                                    %5BExamples%5D-Deploy-Identity-Resources "Wiki - Deploy identity resources"
[wiki_deploy_identity_resources_custom]:                             %5BExamples%5D-Deploy-Identity-Resources-With-Custom-Settings "Wiki - Deploy identity resources with custom settings"
[wiki_deploy_using_module_nesting]:                                  %5BExamples%5D-Deploy-Using-Module-Nesting "Wiki - Deploy using module nesting"
[wiki_deploy_using_multiple_module_declarations_with_orchestration]: %5BExamples%5D-Deploy-using-multiple-module-declarations-with-orchestration "Wiki - Deploy using multiple module declarations with orchestration"
[wiki_deploy_using_multiple_module_declarations_with_remote_state]:  %5BExamples%5D-Deploy-using-multiple-module-declarations-with-remote-state "Wiki - Deploy using multiple module declarations with remote state"
[wiki_frequently_asked_questions]:                                   Frequently-Asked-Questions "Wiki - Frequently Asked Questions"
[wiki_troubleshooting]:                                              Troubleshooting "Wiki - Troubleshooting"
[wiki_contributing]:                                                 Contributing "Wiki - Contributing"
[wiki_raising_an_issue]:                                             Raising-an-Issue "Wiki - Raising an issue"
[wiki_feature_requests]:                                             Feature-Requests "Wiki - Feature requests"
[wiki_contributing_to_code]:                                         Contributing-to-Code "Wiki - Contributing to code"
[wiki_contributing_to_documentation]:                                Contributing-to-Documentation "Wiki - Contributing to documentation"
[wiki_expand_built_in_archetype_definitions]:                        %5BExamples%5D-Expand-Built-in-Archetype-Definitions "Wiki - Expand built-in archetype definitions"
[wiki_override_module_role_assignments]:                             %5BExamples%5D-Override-Module-Role-Assignments "Wiki - Override module role assignments"
[wiki_set_parameter_values_for_policy_assignments]:                  %5BExamples%5D-Set-parameter-values-for-Policy-Assignments "Wiki - Set parameter values for Policy Assignments"
[wiki_create_custom_policies_policy_sets_and_assignments]:           %5BExamples%5D-Create-Custom-Policies-Policy-Sets-and-Assignments "Wiki - Create custom policies, initiatives and assignments"
[wiki_assign_a_built_in_policy]:                                     %5BExamples%5D-Assign-a-Built-in-Policy "Wiki - Assign a built-in policy"
[wiki_create_and_assign_custom_rbac_roles]:                          %5BExamples%5D-Create-and-Assign-Custom-RBAC-Roles "Wiki - Create and assign custom RBAC roles"

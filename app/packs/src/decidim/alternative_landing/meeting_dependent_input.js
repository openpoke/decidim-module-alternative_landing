import createFieldDependentInputs from "src/decidim/admin/field_dependent_inputs.component"

$(() => {
  const $meetingDependentInput = $("#content_block_settings_meetings_component_id");

  createFieldDependentInputs({
    controllerField: $meetingDependentInput,
    wrapperSelector: ".meetings-fields",
    dependentFieldsSelector: ".meetings-fields--individual-picker",
    dependentInputSelector: "input",
    enablingCondition: ($field) => {
      return $field.val() === "custom"
    }
  });
})

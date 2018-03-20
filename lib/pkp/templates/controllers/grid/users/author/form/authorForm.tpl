{**
 * templates/controllers/grid/users/author/form/authorForm.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Submission Contributor grid form
 *
 *}

<script>
	// Attach the Information Center handler.
	$(function() {ldelim}
		$('#editAuthor').pkpHandler(
			'$.pkp.controllers.form.AjaxFormHandler'
		);
	{rdelim});
</script>

<form class="pkp_form" id="editAuthor" method="post" action="{url op="updateAuthor" authorId=$authorId}">
	{csrf}
	{include file="controllers/notification/inPlaceNotification.tpl" notificationId="authorFormNotification"}

	{include
		file="common/userDetails.tpl"
		disableUserNameSection=true
		disableAuthSourceSection=true
		disablePasswordSection=true
		disableSendNotifySection=true
		disableGenderSection=true
		disableSalutationSection=true
		disableInitialsSection=true
		disablePhoneSection=true
		disableLocaleSection=true
		disableInterestsSection=true
		disableMailingSection=true
		disableSignatureSection=true
		extraContentSectionUnfolded=true
		countryRequired=true
	}

	{fbvFormArea id="submissionSpecific"}
		{* {fbvFormSection id="userGroupId" title="submission.submit.contributorRole" list=true}
				{assign var="checked" value=true}
				{fbvElement type="radio" id="userGroup" name="userGroupId" value="14" checked=$checked label="Author" translate=false}
		{/fbvFormSection} *}

		{fbvFormSection list="true"}
			{fbvElement type="checkbox" label="submission.submit.selectPrincipalContact" id="primaryContact" checked=$primaryContact}
			{fbvElement type="checkbox" label="submission.submit.includeInBrowse" id="includeInBrowse" checked=$includeInBrowse}
		{/fbvFormSection}
	{/fbvFormArea}

	{if $submissionId}
		<input type="hidden" name="submissionId" value="{$submissionId|escape}" />
	{/if}
	{if $gridId}
		<input type="hidden" name="gridId" value="{$gridId|escape}" />
	{/if}
	{if $rowId}
		<input type="hidden" name="rowId" value="{$rowId|escape}" />
	{/if}

	<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
	{fbvFormButtons id="step2Buttons" submitText="common.save"}
</form>

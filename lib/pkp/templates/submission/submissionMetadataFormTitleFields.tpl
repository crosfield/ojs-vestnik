{**
 * templates/submission/submissionMetadataFormTitleFields.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Submission's metadata form title fields. To be included in any form that wants to handle
 * submission metadata.
 *}
<div class="pkp_helpers_clear">
	{* {fbvFormSection for="subtitle" title="common.subtitle" size=$fbvStyles.size.MEDIUM}
		{fbvElement label="common.subtitle.tip" type="text" multilingual=true name="subtitle" id="subtitle" value=$subtitle readonly=$readOnly}
	{/fbvFormSection} *}
	{* {fbvFormSection for="title" title="common.prefix" inline="true" size=$fbvStyles.size.SMALL}
		{fbvElement label="common.prefixAndTitle.tip" type="text" multilingual=true name="prefix" id="prefix" value=$prefix readonly=$readOnly maxlength="32"}
	{/fbvFormSection} *}
	{fbvFormSection for="title" title="common.title" required=true}
		{fbvElement type="text" multilingual=true name="title" id="title" value=$title readonly=$readOnly maxlength="255" required=true}
	{/fbvFormSection}
	{fbvFormSection title="common.abstract" for="abstract" required=$abstractsRequired}
		{fbvElement type="textarea" multilingual=true rich=true name="abstract" id="abstract" value=$abstract readonly=$readOnly}
	{/fbvFormSection}
	{fbvFormSection title="article.acknowledgement" for="acknowledgement"}
		{fbvElement type="textarea" multilingual=true name="acknowledgement" id="acknowledgement" value=$acknowledgement readonly=$readOnly}
	{/fbvFormSection}
	{fbvFormSection title="article.udc" for="udc" required=false size=$fbvStyles.size.MEDIUM}
		{fbvElement type="text" multilingual=true name="udc" id="udc" value=$udc readonly=$readOnly}
	{/fbvFormSection}
</div>
<p></p>

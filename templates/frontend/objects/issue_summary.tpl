{**
 * templates/frontend/objects/issue_summary.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Issue which displays a summary for use in lists
 *
 * @uses $issue Issue The issue
 *}
{if $issue->getShowTitle()}
{assign var=issueTitle value=$issue->getLocalizedTitle()}
{/if}
{assign var=issueSeries value=$issue->getIssueSeries()}
{assign var=issueYear value=$issue->getYear()}
{assign var=issueVol value=$issue->getVolume()}
{assign var=issueNum value=$issue->getNumber()}
{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}

<div class="obj_issue_summary">


	{if $issue->getCurrent()}
		<h2>{translate key="issue.vol"} {$issueVol|escape}, {$issueYear|escape}</h2>
	{/if}
	{if $issueYear == '2003'}
		<h2>{$issueYear|escape}</h2>
	{/if}
	{if $issueNum == 4 && !$issueTitle}
			<h2>{translate key="issue.vol"} {$issueVol|escape}, {$issueYear|escape}</h2>
	{/if}
	{if $issueTitle == 'Часть 3'}
		<h2>{translate key="issue.vol"} {$issueVol|escape}, {$issueYear|escape}</h2>
	{/if}
	<time>
		{$issue->getDatePublished()|date_format:"%Y/%m/%e"}
	</time>
	<a class="title" href="{url op="view" path=$issue->getBestIssueId()}">
		{if $issueCover}
			{* <a href="{url op="view" path=$issue->getBestIssueId()}"> *}
				{* <img class="cover" src="{$issueCover|escape}"{if $issue->getLocalizedCoverImageAltText() != ''} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}> *}
			{* </a> *}
		{/if}
		{if $issueTitle}
			<h1>{translate key="issue.no"} {$issueNum|escape}; {$issueTitle|escape}</h1>
		{else}
			<h1>{translate key="issue.no"} {$issueNum|escape}</h1>
		{/if}
	</a>
	{if $issueTitle && $issueSeries}
		<div class="series">
			{* {$issueSeries|escape} *}
		</div>
	{/if}

	<div class="description">
		{$issue->getLocalizedDescription()|strip_unsafe_html}
	</div>
</div><!-- .obj_issue_summary -->

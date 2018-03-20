{**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article which displays all details about the article.
 *  Expected to be primary object on the page.
 *
 * Many journals will want to add custom data to this object, either through
 * plugins which attach to hooks on the page or by editing the template
 * themselves. In order to facilitate this, a flexible layout markup pattern has
 * been implemented. If followed, plugins and other content can provide markup
 * in a way that will render consistently with other items on the page. This
 * pattern is used in the .main_entry column and the .entry_details column. It
 * consists of the following:
 *
 * <!-- Wrapper class which provides proper spacing between components -->
 * <div class="item">
 *     <!-- Title/value combination -->
 *     <div class="label">Abstract</div>
 *     <div class="value">Value</div>
 * </div>
 *
 * All styling should be applied by class name, so that titles may use heading
 * elements (eg, <h3>) or any element required.
 *
 * <!-- Example: component with multiple title/value combinations -->
 * <div class="item">
 *     <div class="sub_item">
 *         <div class="label">DOI</div>
 *         <div class="value">12345678</div>
 *     </div>
 *     <div class="sub_item">
 *         <div class="label">Published Date</div>
 *         <div class="value">2015-01-01</div>
 *     </div>
 * </div>
 *
 * <!-- Example: component with no title -->
 * <div class="item">
 *     <div class="value">Whatever you'd like</div>
 * </div>
 *
 * Core components are produced manually below, but can also be added via
 * plugins using the hooks provided:
 *
 * Templates::Article::Main
 * Templates::Article::Details
 *
 * @uses $article Article This article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $primaryGalleys array List of article galleys that are not supplementary or dependent
 * @uses $supplementaryGalleys array List of article galleys that are supplementary
 * @uses $keywords array List of keywords assigned to this article
 * @uses $pubIdPlugins Array of pubId plugins which this article may be assigned
 * @uses $copyright string Copyright notice. Only assigned if statement should
 *   be included with published articles.
 * @uses $copyrightHolder string Name of copyright holder
 * @uses $copyrightYear string Year of copyright
 * @uses $licenseUrl string URL to license. Only assigned if license should be
 *   included with published articles.
 * @uses $ccLicenseBadge string An image and text with details about the license
 *}

<article class="obj_article_details">
	<h1 class="page_title">
		{if $article->getLocale() == 'en_US' && $currentLocale == 'ru_RU'}
				{$article->getTitle('en_US')|strip_unsafe_html}
				<div class="title_nonlocalized">[ {$article->getTitle('ru_RU')|strip_unsafe_html} ]</div>
		{else}
				{$article->getLocalizedTitle()|strip_unsafe_html}
		{/if}
	</h1>

	{if $article->getLocalizedSubtitle()}
		<h2 class="subtitle">
			{$article->getLocalizedSubtitle()|escape}
		</h2>
	{/if}

	<div class="row">
		<div class="main_entry">

			{if $article->getAuthors()}
				<ul class="item authors">
					{foreach from=$article->getAuthors() item=author}
					{assign var=authorCountry value=$author->getCountryLocalized()}
						<li>
							<span class="name">
								{if $article->getLocale() == 'en_US' && $currentLocale == 'ru_RU'}
									{$author->getFullNameInitials_en_US()|escape}
								{else}
									{$author->getFullNameInitials()|escape}
								{/if}
							</span>
							{if $author->getLocalizedAffiliation()}
								<span class="affiliation">
									{$author->getLocalizedAffiliation()}{if $authorCountry}, {$authorCountry|escape}{/if}
								</span>
							{/if}
							{if $author->getOrcid()}
								<span class="orcid">
									{$orcidIcon}
									<a href="{$author->getOrcid()|escape}" target="_blank">
										{$author->getOrcid()|escape}
									</a>
								</span>
							{/if}
						</li>
					{/foreach}
				</ul>
			{/if}

			{* Article UDC *}
			{if $article->getLocalizedUdc()}
				{if $currentLocale == 'ru_RU'}
				<div class="item doi">
					<span class="label">
						{capture assign=translatedSubjects}{translate key="article.udc"}{/capture}
						{translate key="semicolon" label=$translatedSubjects}
					</span>
					<span class="value">
						{$article->getLocalizedUdc()|strip_unsafe_html|nl2br}
					</span>
				</div>
				{/if}
			{/if}

			{* DOI (requires plugin) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() != 'doi'}
					{php}continue;{/php}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
					<div class="item doi">
						{* <span class="label">
							{capture assign=translatedDOI}{translate key="plugins.pubIds.doi.readerDisplayName"}{/capture}
							{translate key="semicolon" label=$translatedDOI}
						</span> *}
						<span class="value">
							<a href="{$doiUrl}">
								{$doiUrl}
							</a>
						</span>
					</div>
				{/if}
			{/foreach}

			{* Abstract *}
			{if $article->getLocalizedAbstract()}
				<div class="item abstract">
					{if $article->getAuthors()}
						<h3 class="label">{translate key="article.abstract"}</h3>
					{/if}
					{$article->getLocalizedAbstract()|strip_unsafe_html}
				</div>
			{/if}

			{* Keywords *}
			{if !empty($keywords[$currentLocale])}
			<div class="item keywords">
				<span class="label">
					{capture assign=translatedKeywords}{translate key="article.keywords"}{/capture}
					{translate key="semicolon" label=$translatedKeywords}
				</span>
				<span class="value">
					{* <p> *}
					{foreach from=$keywords item=keyword}
						{foreach name=keywords from=$keyword item=keywordItem}
							{$keywordItem|escape}{if !$smarty.foreach.keywords.last}, {/if}
						{/foreach}
					{/foreach}
					{* </p> *}
				</span>
			</div>
			{/if}

			{call_hook name="Templates::Article::Main"}

			{* Author biographies *}
			{assign var="hasBiographies" value=0}
			{foreach from=$article->getAuthors() item=author}
				{if $author->getLocalizedBiography()}
					{assign var="hasBiographies" value=$hasBiographies+1}
				{/if}
			{/foreach}
			{if $hasBiographies}
				<div class="item author_bios">
					<h3 class="label">
						{if $hasBiographies > 1}
							{translate key="submission.authorBiographies"}
						{else}
							{translate key="submission.authorBiography"}
						{/if}
					</h3>
					{foreach from=$article->getAuthors() item=author}
						{if $author->getLocalizedBiography()}
							<div class="sub_item">
								<div class="label">
									{* {if $author->getLocalizedAffiliation()} *}
										{$author->getFullName()|escape}
										{* {capture assign="authorName"}{$author->getFullName()|escape}{/capture} *}
										{* {capture assign="authorAffiliation"}<span class="affiliation">{$author->getLocalizedAffiliation()|escape}</span>{/capture} *}
										{* {translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliation} *}
									{* {else}
										{$author->getFullName()|escape}
									{/if} *}
								</div>
								<div class="value">
										{$author->getLocalizedBiography()|strip_unsafe_html}
										{if $author->getEmail()}
										{assign var="contact" value=$author->getData('primaryContact')}
											<div>{if $contact eq 1}{assign var="ifcontact" value=1} <span class="correspond"></span>{/if} e-mail: {$author->getEmail()}</div>
										{/if}
								</div>
							</div>
						{/if}
					{/foreach}
					{* {if $ifcontact}
						<div class="correspond">
							{translate key="submission.principalContact"}
						</div>
					{/if} *}
				</div>
			{/if}

			{* References *}
			{if $article->getLocalizedCitations()}
				<div class="item rerefences">
					<h3 class="label">
						{translate key="submission.citations"}
					</h3>
					<div class="value">
						{$article->getLocalizedCitations()}
					</div>
				</div>
			{/if}

			{* Acknowledgement *}
			{if $article->getLocalizedAcknowledgement()}
				<div class="item abstract">
					<h3 class="label">{translate key="article.acknowledgement"}</h3>
					<p>{$article->getLocalizedAcknowledgement()|strip_unsafe_html}</p>
				</div>
			{/if}

		</div><!-- .main_entry -->

		<div class="entry_details">

			{* Article/Issue cover image *}
			{if $article->getLocalizedCoverImage() || $issue->getLocalizedCoverImage()}
				<div class="item cover_image cover-container" id="lightgallery">
					<div class="sub_item" data-src="{$article->getLocalizedCoverImageUrl()|escape}">
						{if $article->getLocalizedCoverImage()}
								<img class="img-responsive" src="{$article->getLocalizedCoverImageUrl()|escape}"{if $article->getLocalizedCoverImageAltText()} alt="{$article->getLocalizedCoverImageAltText()|escape}"{/if}>
								<a href="#"><span class="fa fa-eye fa-5x"></span></a>
						{else}
							<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
								<img src="{$issue->getLocalizedCoverImageUrl()|escape}"{if $issue->getLocalizedCoverImageAltText()} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>
							</a>
						{/if}
					</div>
				</div>
			{/if}

			{* Article Galleys *}
			{if $supplementaryGalleys}
					<div class="item galleys">
						<ul class="value supplementary_galleys_links">
							{foreach from=$supplementaryGalleys item=galley}
								<li>
									{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley isSupplementary="1"}
								</li>
							{/foreach}
						</ul>
					</div>
			{/if}
			{if $primaryGalleys}
				<div class="item galleys">
					<ul class="value galleys_links">
						{foreach from=$primaryGalleys item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}

			{* Issue article appears in *}
			<div class="item issue">
				<div class="sub_item">
					<div class="label">
						{translate key="issue.issue"}
					</div>
					<div class="value">
						<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
							{$issue->getIssueIdentification()}
						</a>
					</div>
				</div>

				{* Page numbers for this article *}
				{if $article->getPages()}
					<div class="sub_item">
						<div class="label">
							{translate key="article.pages"}
						</div>
						<div class="value">
							{$article->getPages()|escape}
						</div>
					</div>
				{/if}

				{if !$section->getHideTitle()}
					{if $section}
						<div class="sub_item">
							<div class="label">
								{translate key="section.section"}
							</div>
							<div class="value">
								{$section->getLocalizedTitle()|escape}
							</div>
						</div>
					{/if}
				{/if}
			</div>

			{* {if !$section->getHideTitle()} *}
				{if $article->getDateSubmitted()}
					<div class="item published">
						<div class="label">
							{translate key="submissions.submitted"}
						</div>
						<div class="value">
							{$article->getDateSubmitted()|date_format:$dateFormatShort}
						</div>
					</div>
				{/if}

				{* {if !$section->getHideTitle()} *}
					<div class="item published">
						<div class="label">
							{translate key="submissions.published"}
						</div>
						<div class="value">
							{$article->getDatePublished()|date_format:$dateFormatShort}
						</div>
					</div>
				{* {/if} *}
			{* {/if} *}

						{* How to cite *}
						{if $citation}
							<div class="item citation">
								<div class="sub_item citation_display">
									<div class="label">
										{translate key="submission.howToCite"}
									</div>
									<div class="value">
										<div id="citationOutput" role="region" aria-live="polite">
											{$citation}
										</div>
										<div class="citation_formats">
											<button class="cmp_button citation_formats_button" aria-controls="cslCitationFormats" aria-expanded="false" data-csl-dropdown="true">
												{translate key="submission.howToCite.citationFormats"}
											</button>
											<div id="cslCitationFormats" class="citation_formats_list" aria-hidden="true">
												<ul class="citation_formats_styles">
													{foreach from=$citationStyles item="citationStyle"}
														<li>
															<a
																aria-controls="citationOutput"
																href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
																data-load-citation
																data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
															>
																{$citationStyle.title|escape}
															</a>
														</li>
													{/foreach}
												</ul>
												{if count($citationDownloads)}
													<div class="label">
														{translate key="submission.howToCite.downloadCitation"}
													</div>
													<ul class="citation_formats_styles">
														{foreach from=$citationDownloads item="citationDownload"}
															<li>
																<a href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
																	<span class="fa fa-download"></span>
																	{$citationDownload.title|escape}
																</a>
															</li>
														{/foreach}
													</ul>
												{/if}
											</div>
										</div>
									</div>
								</div>
							</div>
						{/if}

			{* PubIds (requires plugins) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() == 'doi'}
					{php}continue;{/php}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					<div class="item pubid">
						<div class="label">
							{$pubIdPlugin->getPubIdDisplayType()|escape}
						</div>
						<div class="value">
							{if $pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								<a id="pub-id::{$pubIdPlugin->getPubIdType()|escape}" href="{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}">
									{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								</a>
							{else}
								{$pubId|escape}
							{/if}
						</div>
					</div>
				{/if}
			{/foreach}

			{* Licensing info *}
			{if $copyright || $copyrightHolder}
				<div class="item copyright">
					{assign var="curYear" value='Y'|date}
					{assign var="pubYear" value=$issue->getYear()}
					{assign var="licyears" value=`$curYear-$pubYear`}
					{if $article->getAuthorStringInitials_en_US() || $article->getAuthorStringInitials()}
						{if $article->getLocale() == 'en_US' && $currentLocale == 'ru_RU'}
							©️ {$article->getAuthorStringInitials_en_US()}, {$issue->getYear()}<br>
						{else}
							©️ {$article->getAuthorStringInitials()}, {$issue->getYear()}<br>
						{/if}
					{else}
						©️ {$currentContext->getLocalizedName()}, {$pubYear}
					{/if}
					{if $licyears <= 5}
					©️ {$currentContext->getLocalizedName()}, {$pubYear}
					{/if}
					{* {if $copyrightHolder}
						{if $ccLicenseBadge}
							{$ccLicenseBadge}
						{else}
							<a href="{$licenseUrl|escape}" class="copyright">
								{if $copyrightHolder}
									{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder copyrightYear=$copyrightYear}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{/if} *}
					{* <p>{$copyright|strip_tags|substr:0:-1}, {$copyrightYear}</p> *}
				</div>
			{/if}

			{call_hook name="Templates::Article::Details"}

		</div><!-- .entry_details -->
	</div><!-- .row -->

</article>

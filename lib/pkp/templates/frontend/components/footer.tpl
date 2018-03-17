{**
 * templates/frontend/components/footer.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Common site frontend footer.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}

	</div><!-- pkp_structure_main -->

	{* Sidebars *}
	{if empty($isFullWidth)}
		{call_hook|assign:"sidebarCode" name="Templates::Common::Sidebar"}
		{if $sidebarCode}
			<div class="pkp_structure_sidebar left" role="complementary" aria-label="{translate|escape key="common.navigation.sidebar"}">
				{$sidebarCode}

				{* Announcements *}
				{if $numAnnouncementsHomepage && $announcements|@count}
					<div class="pkp_block block_information">
						<span class="title">
							{translate key="announcement.announcements"}
						</span>
						{foreach name=announcements from=$announcements item=announcement}
							{if $smarty.foreach.announcements.iteration > $numAnnouncementsHomepage}
								{php}break;{/php}
							{/if}
							{if $smarty.foreach.announcements.iteration == 1}
								{include file="frontend/objects/announcement_summary.tpl" heading="h3"}
								<div class="more">
							{else}
								<article class="obj_announcement_summary">
									<h4>
										<a href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->getId()}">
											{$announcement->getLocalizedTitle()|escape}
										</a>
									</h4>
									<div class="date">
										{$announcement->getDatePosted()}
									</div>
								</article>
							{/if}
						{/foreach}
						</div><!-- .more -->
					</div>
				{/if}
				<div class="pkp_block marks">
					<a href="https://pkp.sfu.ca/ojs/">
						<img alt="{translate key="about.aboutThisPublishingSystem"}" src="{$baseUrl}/{$brandImage}">
					</a>
					<a href="https://www.crossref.org">
						<img src="https://assets.crossref.org/logo/crossref-content-registration-logo-200.svg" alt="Crossref Content Registration logo">
					</a>
				</div>
			</div><!-- pkp_sidebar.left -->
		{/if}
	{/if}
</div><!-- pkp_structure_content -->

<div id="pkp_content_footer" class="pkp_structure_footer_wrapper" role="contentinfo">

	<div class="pkp_structure_footer">

		{if $pageFooter}
			<div class="pkp_footer_content">
				{$pageFooter|strip_tags}&nbsp;&nbsp;·&nbsp;&nbsp;&nbsp;Powered by <a href="{url page="about" op="aboutThisPublishingSystem"}">OJS /PKP</a>
			</div>
		{/if}

		{* <div class="pkp_brand_footer" role="complementary">
			<a href="{url page="about" op="aboutThisPublishingSystem"}">
				<img alt="{translate key="about.aboutThisPublishingSystem"}" src="{$baseUrl}/{$brandImage}">
			</a>
		</div> *}
	</div>
</div><!-- pkp_structure_footer_wrapper -->

</div><!-- pkp_structure_page -->

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}

</body>
</html>

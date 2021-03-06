{**
 * templates/controllers/grid/settings/section/form/sectionForm.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Section form under journal management.
 *}

<script type="text/javascript">
	$(function() {ldelim}
		// Attach the form handler.
		$('#sectionForm').pkpHandler(
			'$.pkp.controllers.form.FileUploadFormHandler',
			{ldelim}
				$uploader: $('#coverImageUploader'),
				$preview: $('#coverImagePreview'),
				uploaderOptions: {ldelim}
					uploadUrl: {url|json_encode op="uploadImage" escape=false},
					baseUrl: {$baseUrl|json_encode},
					filters: {ldelim}
						mime_types : [
							{ldelim} title : "Image files", extensions : "jpg,jpeg,png,svg" {rdelim}
						]
					{rdelim}
				{rdelim}
			{rdelim}
	);
	{rdelim});
</script>
<form class="pkp_form" id="sectionForm" method="post" action="{url router=$smarty.const.ROUTE_COMPONENT component="plugins.themes.immersion.controllers.grid.ImmersionSectionGridHandler" op="updateSection" sectionId=$sectionId}">
	{csrf}
	<input type="hidden" name="sectionId" value="{$sectionId|escape}"/>

	{include file="controllers/notification/inPlaceNotification.tpl" notificationId="sectionFormNotification"}

	{if $sectionEditorCount == 0}
		<span class="pkp_form_error"><p>{translate key="manager.section.noSectionEditors"}</p></span>
	{/if}

	{fbvFormArea id="sectionInfo"}
		{fbvFormSection}
			{fbvElement type="text" multilingual=true id="title" label="section.title" value=$title maxlength="80" size=$fbvStyles.size.MEDIUM inline=true required=true}
			{fbvElement type="text" multilingual=true id="abbrev" label="section.abbreviation" value=$abbrev maxlength="80" size=$fbvStyles.size.SMALL inline=true required=true}
		{/fbvFormSection}

		{fbvFormSection title="manager.sections.policy" for="policy"}
			{fbvElement type="textarea" multilingual=true id="policy" value=$policy rich=true}
		{/fbvFormSection}
	{/fbvFormArea}

	{fbvFormArea id="sectionMisc"}
		{fbvFormSection title="manager.sections.wordCount" for="wordCount" inline=true size=$fbvStyles.size.MEDIUM}
			{fbvElement type="text" id="wordCount" value=$wordCount maxlength="80" label="manager.sections.wordCountInstructions"}
		{/fbvFormSection}

		{fbvFormSection title="submission.reviewForm" for="reviewFormId" inline=true size=$fbvStyles.size.MEDIUM}
			{fbvElement type="select" id="reviewFormId" defaultLabel="manager.reviewForms.noneChosen"|translate defaultValue="" from=$reviewFormOptions selected=$reviewFormId translate=false size=$fbvStyles.size.MEDIUM inline=true}
		{/fbvFormSection}

		{fbvFormSection title="plugins.themes.immersion.colorPick" for="immersionColorPick" inline=false size=$fbvStyles.size.MEDIUM}
			{fbvElement type="colour" id="immersionColorPick" value=$immersionColorPick maxlength="7" label="plugins.themes.immersion.colorPickInstructions"}
		{/fbvFormSection}

		{call_hook name="Templates::Manager::Sections::SectionForm::AdditionalMetadata" sectionId=$sectionId}
	{/fbvFormArea}

	{fbvFormArea id="immersionCoverImage" title="plugins.themes.immersion.section.coverPage"}
		{fbvFormSection}
			{include file="controllers/fileUploadContainer.tpl" id="coverImageUploader"}
			<input type="hidden" name="temporaryFileId" id="temporaryFileId" value="" />
		{/fbvFormSection}
		{fbvFormSection id="coverImagePreview"}
		{if $immersionCoverImage != ''}
			<div class="pkp_form_file_view pkp_form_image_view">
				<div class="img">
					<img src="{$publicFilesDir}/{$immersionCoverImage|escape:"url"}{'?'|uniqid}" {if $immersionCoverImageAlt !== ''} alt="{$immersionCoverImageAlt|escape}"{/if}>
				</div>

				<div class="data">
							<span class="title">
								{translate key="common.altText"}
							</span>
					<span class="value">
								{fbvElement type="text" id="immersionCoverImageAltText" label="common.altTextInstructions" value=$immersionCoverImageAltText}
							</span>

					<div id="{$deleteCoverImageLinkAction->getId()}" class="actions">
						{include file="linkAction/linkAction.tpl" action=$deleteCoverImageLinkAction contextId="sectionForm"}
					</div>
				</div>
			</div>
		{/if}
		{/fbvFormSection}
	{/fbvFormArea}

	{fbvFormArea id="indexingInfo" title="submission.indexing"}
		{fbvFormSection list=true}
			{fbvElement type="checkbox" id="metaReviewed" checked=$metaReviewed label="manager.sections.submissionReview"}
			{fbvElement type="checkbox" id="abstractsNotRequired" checked=$abstractsNotRequired label="manager.sections.abstractsNotRequired"}
			{fbvElement type="checkbox" id="metaIndexed" checked=$metaIndexed label="manager.sections.submissionIndexing"}
			{fbvElement type="checkbox" id="editorRestriction" checked=$editorRestriction label="manager.sections.editorRestriction"}
			{fbvElement type="checkbox" id="hideTitle" checked=$hideTitle label="manager.sections.hideTocTitle"}
			{fbvElement type="checkbox" id="hideAuthor" checked=$hideAuthor label="manager.sections.hideTocAuthor"}
		{/fbvFormSection}

		{fbvFormSection for="identifyType" title="manager.sections.identifyType"}
			{fbvElement type="text" id="identifyType" label="manager.sections.identifyTypeExamples" value=$identifyType multilingual=true size=$fbvStyles.size.MEDIUM}
		{/fbvFormSection}
	{/fbvFormArea}

	{if $hasSubEditors}
		{fbvFormSection}
			{assign var="uuid" value=""|uniqid|escape}
			<div id="subeditors-{$uuid}">
				<script type="text/javascript">
					pkp.registry.init('subeditors-{$uuid}', 'SelectListPanel', {$subEditorsListData});
				</script>
			</div>
		{/fbvFormSection}
	{/if}
	{fbvFormButtons submitText="common.save"}
</form>


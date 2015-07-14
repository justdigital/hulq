<!-- *** START OF STYLESHEET *** -->

<!-- **********************************************************************
 XSL to format the search output for Google Search Appliance
     ********************************************************************** -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

<!-- **********************************************************************
  GSA embedded mode support for websites that wants to display GSA search
  experience embedded inside the parent container via  proxying the
  request to the GSA. DO NOT EDIT the below part.
*************************************************************************** -->
<!-- Incoming query parameter identifying root path prefix to be used for links
     that should refresh the main page. -->
<xsl:variable name="embedded_mode_root_path_param" select="'emmain'" />
<!-- Incoming query parameter identifying root path prefix to be used for
     resources that should be loaded in isolation e.g. images, CSS, JS,
     AJAX requests etc. over an HTTP connection. -->
<xsl:variable name="embedded_mode_resource_root_path_param"
    select="'emsingleres'" />
<!-- Incoming query parameter for enabling/disabling style for embedded
     mode. -->
<xsl:variable name="embedded_mode_disable_style" select="'emdstyle'" />
<!-- Incoming query parameter specifying the GSA host name to be used for
     documill full preview viewer. -->
<xsl:variable name="embedded_mode_dps_viewer_param" select="'emdvhost'" />
<!-- Root path prefix for full-refresh requests that should be used instead
     of GSA's default "/search" root path prefix. -->
<xsl:variable name="embedded_mode_root_path_prefix"
    select="/GSP/PARAM[@name=$embedded_mode_root_path_param]/@value" />
<!-- Root path prefix for resources (e.g. CSS, images, JavaScript, AJAX requests
     etc.) that should be used instead of GSA's default "/" root path
     prefix. -->
<xsl:variable name="embedded_mode_resource_root_path_prefix"
    select="/GSP/PARAM[@name=$embedded_mode_resource_root_path_param]/@value" />
<!-- The GSA host to be used for documill full preview viewer. -->
<xsl:variable name="embedded_mode_dps_viewer_host"
    select="/GSP/PARAM[@name=$embedded_mode_dps_viewer_param]/@value" />
<!-- Checks if style should be disabled in embedded mode or not. -->
<xsl:variable name="is_disable_style_in_embedded_mode"
  select="
  if (/GSP/PARAM[@name=$embedded_mode_disable_style]/@value = 'true') then '1'
  else '0'" />
<!-- Regex for matching relative path starting with a '/' character
     and not having a following '/' character. -->
<xsl:variable name="relative_path_only_regex">^(/)[^/].*</xsl:variable>
<!-- Checks if the incoming root path prefix arguments are relative paths as
     we don't want to allow absolute paths. -->
<xsl:variable name="invalid_embedded_mode_request" >
  <xsl:if test="
      not(matches(
          $embedded_mode_root_path_prefix, $relative_path_only_regex)) or
      not(matches(
          $embedded_mode_resource_root_path_prefix, $relative_path_only_regex))">
    <xsl:value-of select="'1'" />
  </xsl:if>
</xsl:variable>
<!-- Flag to signal if current mode is embeddeded or not.
     '1' - yes, '0' - No -->
<xsl:variable name="is_embedded_mode"
    select="if ($embedded_mode_root_path_prefix != '' and
                $invalid_embedded_mode_request != '1') then '1' else '0'" />

<!-- **********************************************************************
  Root path prefix variables that should be used for search and static
  resources throughout.
********************************************************************** -->
<!-- Root path prefix for search requests that should be used instead of GSA's
     default "/search" root path prefix. -->
<xsl:variable name="gsa_search_root_path_prefix">
  <xsl:choose>
    <xsl:when test="$embedded_mode_root_path_prefix != '' and
                    $invalid_embedded_mode_request != '1'">
      <xsl:value-of select="$embedded_mode_root_path_prefix" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'/search'" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<!-- Root path prefix for resources files (e.g. CSS, images, JavaScript etc.)
     and other HTTP requests that should be processed in isolation
     (e.g. Iframe, AJAX etc.) -->
<xsl:variable name="gsa_resource_root_path_prefix">
  <xsl:choose>
    <xsl:when test="$embedded_mode_resource_root_path_prefix != '' and
                    $invalid_embedded_mode_request != '1'">
      <xsl:value-of select="$embedded_mode_resource_root_path_prefix" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="''" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- **********************************************************************
 include customer-onebox.xsl, which is auto-generated from the customer's
 set of OneBox Module definitions, and in turn invokes either the default
 OneBox template, or the customer's:
********************************************************************** -->
<xsl:include href="customer-onebox.xsl"/>

<!--
  Expert Search - Include the expert search XSL to get expert search
  functionality. Please DO NOT remove this import as template and
  variables inside this XSL are being used below. To find all expert search
  related changes in this XSL search for "Expert Search" (quotes for clarity)
  string.
-->
<xsl:include href="expertsearch.xsl"/>

<xsl:output method="html"/>

<!-- **********************************************************************
 Logo setup (can be customized)
     - whether to show logo: 0 for FALSE, 1 (or non-zero) for TRUE
     - logo url
     - logo size: '' for default image size
     ********************************************************************** -->
<xsl:variable name="show_logo">1</xsl:variable>
<xsl:variable name="logo_url"><xsl:value-of
    select="$gsa_resource_root_path_prefix" />images/Title_Left.png</xsl:variable>
<xsl:variable name="logo_width">200</xsl:variable>
<xsl:variable name="logo_height">78</xsl:variable>

<!-- **********************************************************************
 Global Style variables (can be customized): '' for using browser's default
     ********************************************************************** -->

<xsl:variable name="global_font">arial,sans-serif</xsl:variable>
<xsl:variable name="global_font_size"></xsl:variable>
<xsl:variable name="global_bg_color">#ffffff</xsl:variable>
<xsl:variable name="global_text_color">#000000</xsl:variable>
<xsl:variable name="global_link_color">#0000cc</xsl:variable>
<xsl:variable name="global_vlink_color">#551a8b</xsl:variable>
<xsl:variable name="global_alink_color">#ff0000</xsl:variable>


<!-- **********************************************************************
 Result page components (can be customized)
     - whether to show a component: 0 for FALSE, non-zero (e.g., 1) for TRUE
     - text and style
     ********************************************************************** -->

<!-- *** choose result page header: '', 'provided', 'mine', or 'both' *** -->
<xsl:variable name="choose_result_page_header">both</xsl:variable>

<!-- *** customize provided result page header *** -->
<xsl:variable name="show_swr_link">1</xsl:variable>
<xsl:variable name="swr_search_anchor_text">Search Within Results</xsl:variable>
<xsl:variable name="show_result_page_adv_link">1</xsl:variable>
<xsl:variable name="adv_search_anchor_text">Advanced Search</xsl:variable>
<xsl:variable name="show_result_page_help_link">1</xsl:variable>
<xsl:variable name="search_help_anchor_text">Search Tips</xsl:variable>

<!-- *** search boxes *** -->
<xsl:variable name="show_top_search_box">1</xsl:variable>
<xsl:variable name="show_bottom_search_box">1</xsl:variable>
<xsl:variable name="search_box_size">32</xsl:variable>

<!-- *** choose search button type: 'text' or 'image' *** -->
<xsl:variable name="choose_search_button">text</xsl:variable>
<xsl:variable name="search_button_text">Google Search</xsl:variable>
<xsl:variable name="search_button_image_url"></xsl:variable>
<xsl:variable name="search_collections_xslt"></xsl:variable>

<!-- *** search info bars *** -->
<xsl:variable name="show_search_info">1</xsl:variable>

<!-- *** choose separation bar: 'ltblue', 'blue', 'line', 'nothing' *** -->
<xsl:variable name="choose_sep_bar">ltblue</xsl:variable>
<xsl:variable name="sep_bar_std_text">Search</xsl:variable>
<xsl:variable name="sep_bar_adv_text">Advanced Search</xsl:variable>
<xsl:variable name="sep_bar_error_text">Error</xsl:variable>

<!-- *** navigation bars: '', 'google', 'link', or 'simple'.
         DO NOT use 'google' as the navigation bar type for secure search
         i.e. when access='a' or access='s', unless corpus estimate is enabled
         for all queries in Serving > Query Settings. Read documentation of
         "secure_bottom_navigation_type" variable below. *** -->
<xsl:variable name="show_top_navigation">1</xsl:variable>
<xsl:variable name="choose_bottom_navigation">google</xsl:variable>
<xsl:variable name="my_nav_align">right</xsl:variable>
<xsl:variable name="my_nav_size">-1</xsl:variable>
<xsl:variable name="my_nav_color">#6f6f6f</xsl:variable>

<!-- ***  navigation bar for secure search: DO NOT change.
     Please keep the navigation type as 'simple' for secure search i.e.
     when access='a' or access='s', unless corpus estimate is enabled
     for all queries in Serving > Query Settings, because otherwise results size
     estimation is not available for generating numbered pagination. *** -->
<xsl:variable name="secure_bottom_navigation_type">simple</xsl:variable>

<!-- *** sort by date/relevance *** -->
<xsl:variable name="show_sort_by">1</xsl:variable>

<!-- *** spelling suggestions *** -->
<xsl:variable name="show_spelling">1</xsl:variable>
<xsl:variable name="spelling_text">Did you mean:</xsl:variable>
<xsl:variable name="spelling_text_color">#cc0000</xsl:variable>

<!-- *** synonyms suggestions *** -->
<xsl:variable name="show_synonyms">1</xsl:variable>
<xsl:variable name="synonyms_text">You could also try:</xsl:variable>
<xsl:variable name="synonyms_text_color">#cc0000</xsl:variable>

<!-- *** keymatch suggestions *** -->
<xsl:variable name="show_keymatch">1</xsl:variable>
<xsl:variable name="keymatch_text">KeyMatch</xsl:variable>
<xsl:variable name="keymatch_text_color">#2255aa</xsl:variable>
<xsl:variable name="keymatch_bg_color">#e8e8ff</xsl:variable>

<!-- *** Google Desktop integration *** -->
<xsl:variable name="egds_show_search_tabs">1</xsl:variable>
<xsl:variable name="egds_appliance_tab_label">Appliance</xsl:variable>
<xsl:variable name="egds_show_desktop_results">1</xsl:variable>

<!-- *** onebox information *** -->
<xsl:variable name="show_onebox">1</xsl:variable>
<xsl:variable name="uar_provider"> GSA User-Added Results </xsl:variable>

<!-- *** analytics information *** -->
<xsl:variable name="analytics_account"></xsl:variable>

<!-- *** ASR enabling *** -->
<xsl:variable name="show_asr">1</xsl:variable>

<!-- *** UAR v2, Expert Search - Document directionality. Global variable to
         hold document directionality for the user language. *** -->
<xsl:variable name="document_direction">ltr</xsl:variable>

<!-- *** Dynamic Navigation *** -->
<xsl:variable name="show_dynamic_navigation">1</xsl:variable>
<xsl:variable name="dyn_nav_max_rows">6</xsl:variable>
<!-- Expert Search - render dynamic navigation if expanded mode with dynamic
     navigation is configured for this frontend. -->
<xsl:variable name="render_dynamic_navigation"><xsl:if
  test="($show_dynamic_navigation != '0' or
         $show_expert_search_expanded_results = '1') and
         count(/GSP/RES/PARM) > 0">1</xsl:if>
</xsl:variable>

<!-- *** Show Google Apps results on right side as a sidebar element *** -->
<xsl:variable name="show_apps_segmented_ui">0</xsl:variable>

<!-- *** Google Site Search results *** -->
<xsl:variable name="show_gss_results">0</xsl:variable>
<xsl:variable name="gss_search_engine_id"></xsl:variable>

<!-- *** People Search results *** -->
<xsl:variable name="show_people_search">0</xsl:variable>

<!-- *** Translation Integration *** -->
<xsl:variable name="show_translation">1</xsl:variable>
<xsl:param name="translate_key"/>

<!-- *** Sidebar for holding elements that can load data asynchronously *** -->
<xsl:variable name="show_sidebar">
  <xsl:choose>
    <!-- Expert Search - enable sidebar if expert search widget view is
         configured. -->
    <xsl:when test="($show_apps_segmented_ui = '1' or $show_gss_results = '1' or
                     $show_people_search = '1' or
                     $show_expert_search_widget_view = '1') and
                     $show_expert_search_expanded_results != '1' and
                     $show_dynamic_navigation != '1' and /GSP/Q != '' and
                     ($show_res_clusters = '0' or $res_cluster_position != 'right')">
      <xsl:value-of select="'1'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'0'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- *** Document Previews *** -->
<xsl:variable name="show_document_previews">0</xsl:variable>

<!-- **********************************************************************
 Result elements (can be customized)
     - whether to show an element ('1' for yes, '0' for no)
     - font/size/color ('' for using style of the context)
     ********************************************************************** -->

<!-- *** result title and snippet *** -->
<xsl:variable name="show_res_title">1</xsl:variable>
<xsl:variable name="res_title_length">70</xsl:variable>
<xsl:variable name="res_title_length_default">70</xsl:variable>
<xsl:variable name="res_title_color">#0000cc</xsl:variable>
<xsl:variable name="res_title_size"></xsl:variable>
<xsl:variable name="show_res_snippet">1</xsl:variable>
<xsl:variable name="res_snippet_size">80%</xsl:variable>

<!-- *** keyword match (in title or snippet) *** -->
<xsl:variable name="res_keyword_color"></xsl:variable>
<xsl:variable name="res_keyword_size"></xsl:variable>
<xsl:variable name="res_keyword_format">b</xsl:variable> <!-- 'b' for bold -->

<!-- *** link URL *** -->
<xsl:variable name="show_res_url">1</xsl:variable>
<xsl:variable name="res_url_color">#008000</xsl:variable>
<xsl:variable name="res_url_size">-1</xsl:variable>
<xsl:variable name="truncate_result_urls">1</xsl:variable>
<xsl:variable name="truncate_result_url_length">100</xsl:variable>

<!-- *** misc elements *** -->
<xsl:variable name="show_ips_in_search_url">1</xsl:variable>
<xsl:variable name="show_meta_tags">0</xsl:variable>
<xsl:variable name="show_res_size">1</xsl:variable>
<xsl:variable name="show_res_date">1</xsl:variable>
<xsl:variable name="show_res_cache">1</xsl:variable>

<!-- *** used in result cache link, similar pages link, and description *** -->
<xsl:variable name="faint_color">#7777cc</xsl:variable>

<!-- *** show secure results radio button *** -->
<xsl:variable name="show_secure_radio">1</xsl:variable>

<!-- *** show suggestions (remote aut-completions) *** -->
<xsl:variable name="show_suggest">0</xsl:variable>

<!-- **********************************************************************
 Other variables (can be customized)
     ********************************************************************** -->

<!-- *** page title *** -->
<xsl:variable name="front_page_title">Search Home</xsl:variable>
<xsl:variable name="result_page_title">Search Results</xsl:variable>
<xsl:variable name="adv_page_title">Advanced Search</xsl:variable>
<xsl:variable name="error_page_title">Error</xsl:variable>
<xsl:variable name="swr_page_title">Search Within Results</xsl:variable>

<!-- *** choose adv_search page header: '', 'provided', 'mine', or 'both' *** -->
<xsl:variable name="choose_adv_search_page_header">both</xsl:variable>

<!-- *** cached page header text *** -->
<xsl:variable name="cached_page_header_text">This is the cached copy of</xsl:variable>

<!-- *** error message text *** -->
<xsl:variable name="server_error_msg_text">A server error has occurred.</xsl:variable>
<xsl:variable name="server_error_des_text">Check server response code in details.</xsl:variable>
<xsl:variable name="xml_error_msg_text">Unknown XML result type.</xsl:variable>
<xsl:variable name="xml_error_des_text">View page source to see the offending XML.</xsl:variable>

<!-- *** advanced search page panel background color *** -->
<xsl:variable name="adv_search_panel_bgcolor">#cbdced</xsl:variable>

<!-- *** dynamic result cluster options *** -->
<xsl:variable name="show_res_clusters">0</xsl:variable>
<xsl:variable name="res_cluster_position">right</xsl:variable>

<!-- *** alerts2 options *** -->
<xsl:variable name="show_alerts2">0</xsl:variable>

<!-- Expert Search - i18n messages used by the expert search UI component. -->
<xsl:variable name="msg_back_to_main_results_action"><![CDATA[Back to main results]]></xsl:variable>
<xsl:variable name="msg_expert_search_no_experts_found"><![CDATA[No expert(s) found.]]></xsl:variable>
<xsl:variable name="msg_expert_search_switch_to_expanded_mode"><![CDATA[Switch to the expert search results expanded mode]]></xsl:variable>
<xsl:variable name="msg_go_to_previous_page"><![CDATA[Go to the previous results page]]></xsl:variable>
<xsl:variable name="msg_go_to_next_page"><![CDATA[Go to the next results page]]></xsl:variable>
<xsl:variable name="msg_loading_expert_results"><![CDATA[Loading results...]]></xsl:variable>
<xsl:variable name="msg_next_page_action"><![CDATA[Next]]></xsl:variable>
<xsl:variable name="msg_previous_page_action"><![CDATA[Prev]]></xsl:variable>
<xsl:variable name="msg_results_page_number_prefix"><![CDATA[Page]]></xsl:variable>

<!-- *** UAR i18n messages *** -->
<xsl:variable name="msg_uar_added_by"><![CDATA[Added by]]></xsl:variable>
<xsl:variable name="msg_uar_edit"><![CDATA[Edit]]></xsl:variable>
<xsl:variable name="msg_uar_title"><![CDATA[Title]]></xsl:variable>
<xsl:variable name="msg_uar_save"><![CDATA[Save]]></xsl:variable>
<xsl:variable name="msg_uar_cancel"><![CDATA[Cancel]]></xsl:variable>
<xsl:variable name="msg_uar_ok"><![CDATA[Ok]]></xsl:variable>
<xsl:variable name="msg_uar_address"><![CDATA[Address]]></xsl:variable>
<xsl:variable name="msg_uar_or"><![CDATA[or]]></xsl:variable>
<xsl:variable name="msg_uar_delete"><![CDATA[delete]]></xsl:variable>
<xsl:variable name="msg_uar_username"><![CDATA[UserName]]></xsl:variable>
<xsl:variable name="msg_uar_less"><![CDATA[Less]]></xsl:variable>
<xsl:variable name="msg_uar_more"><![CDATA[More]]></xsl:variable>
<xsl:variable name="msg_uar_add_another_result"><![CDATA[Add another result]]></xsl:variable>
<xsl:variable name="msg_uar_add_a_result"><![CDATA[Add a result]]></xsl:variable>
<xsl:variable name="msg_uar_saving"><![CDATA[Saving]]></xsl:variable>
<xsl:variable name="msg_uar_deleting"><![CDATA[Deleting]]></xsl:variable>
<xsl:variable name="msg_uar_save_failed"><![CDATA[Save failed]]></xsl:variable>
<xsl:variable name="msg_uar_delete_failed"><![CDATA[Deletion failed]]></xsl:variable>
<xsl:variable name="msg_uar_error_handling_request"><![CDATA[Error handling this request]]></xsl:variable>
<xsl:variable name="msg_uar_error_deleting"><![CDATA[Error deleting this result! Could not create the request]]></xsl:variable>
<xsl:variable name="msg_uar_error_add_or_update"><![CDATA[Problem adding/updating this result: Could not create the request]]></xsl:variable>

<!-- UAR v2 - i18n messages used by the UAR UI component. -->
<xsl:variable name="msg_uar_confirm_delete_title"><![CDATA[Confirm delete]]></xsl:variable>
<xsl:variable name="msg_uar_confirm_delete_text"><![CDATA[Are you sure you want to delete the user added result?]]></xsl:variable>
<xsl:variable name="msg_uar_confirm_delete_moderation_required"><![CDATA[Are you sure you want to delete the user added resultThe selected result will be deleted only after the administrator reviews and approves the same. The result will continue to show until review is done.]]></xsl:variable>
<xsl:variable name="msg_uar_delete_in_progress"><![CDATA[Deleting...]]></xsl:variable>
<xsl:variable name="msg_uar_add_pending_review_title"><![CDATA[New addition - Admin review pending]]></xsl:variable>
<xsl:variable name="msg_uar_add_pending_review_content"><![CDATA[The result that you contributed has been submitted but it will be displayed only after the administrator reviews and approves the same.]]></xsl:variable>
<xsl:variable name="msg_uar_update_pending_review_title"><![CDATA[Edit - Admin review pending]]></xsl:variable>
<xsl:variable name="msg_uar_update_pending_review_content"><![CDATA[The changes to result that you edited has been submitted but it will be displayed only after the administrator reviews and approves the same.]]></xsl:variable>
<xsl:variable name="msg_uar_delete_pending_review_title"><![CDATA[Delete - Admin review pending]]></xsl:variable>
<xsl:variable name="msg_uar_delete_pending_review_content"><![CDATA[The request for deleting the result has been submitted but result will be deleted only after the administrator reviews and approves the same.]]></xsl:variable>
<xsl:variable name="msg_uar_existing_review_pending_title"><![CDATA[Existing admin review pending]]></xsl:variable>
<xsl:variable name="msg_uar_existing_review_pending_content"><![CDATA[An existing request to update the same result is pending therefore this request is not processed. You can take action only after the administrator reviews the existing request.]]></xsl:variable>
<xsl:variable name="msg_uar_confirm_add_title"><![CDATA[Confirm add - Admin review required]]></xsl:variable>
<xsl:variable name="msg_uar_confirm_add_content"><![CDATA[New result contribution will be submitted for administrator review. The result will be displayed only after the administrator will approve the same.]]></xsl:variable>
<xsl:variable name="msg_uar_confirm_update_title"><![CDATA[Confirm edit - Admin review required]]></xsl:variable>
<xsl:variable name="msg_uar_confirm_update_content"><![CDATA[The changes to the result will be submitted for administrator review. The existing result will continue to show until the administrator approves the changes.]]></xsl:variable>
<xsl:variable name="msg_uar_confirm_submit_request"><![CDATA[Are you sure you want to submit this request?]]></xsl:variable>
<xsl:variable name="msg_uar_review_note"><![CDATA[Note that the existing result will continue to show until the review is done.]]></xsl:variable>
<xsl:variable name="msg_uar_discard_changes_title"><![CDATA[Discard changes]]></xsl:variable>
<xsl:variable name="msg_uar_discard_changes_content"><![CDATA[Do you want to discard existing changes?]]></xsl:variable>
<xsl:variable name="msg_uar_no_results"><![CDATA[No results. Consider contributing a result.]]></xsl:variable>
<xsl:variable name="msg_uar_description"><![CDATA[Description]]></xsl:variable>
<xsl:variable name="msg_uar_enter_title_value"><![CDATA[Enter title to be displayed]]></xsl:variable>
<xsl:variable name="msg_uar_enter_url_value"><![CDATA[Enter absolute URL of the document]]></xsl:variable>
<xsl:variable name="msg_uar_enter_username_value"><![CDATA[Enter user name]]></xsl:variable>
<xsl:variable name="msg_uar_edit_this_result"><![CDATA[Edit this result]]></xsl:variable>
<xsl:variable name="msg_uar_delete_this_result"><![CDATA[Delete this result]]></xsl:variable>
<xsl:variable name="msg_uar_view_all_results"><![CDATA[View all results]]></xsl:variable>
<xsl:variable name="msg_uar_hide_few_results"><![CDATA[Hide few results]]></xsl:variable>
<xsl:variable name="msg_uar_contribute_result"><![CDATA[Contribute a result]]></xsl:variable>
<xsl:variable name="msg_uar_loading_settings"><![CDATA[Loading settings. Please try again in a second.]]></xsl:variable>
<xsl:variable name="msg_uar_server_error"><![CDATA[Server error! Please try again.]]></xsl:variable>
<xsl:variable name="msg_uar_authn_required"><![CDATA[Authentication is required.]]></xsl:variable>
<xsl:variable name="msg_uar_username_required"><![CDATA[Username is required. Please specify the same.]]></xsl:variable>
<xsl:variable name="msg_uar_save_in_progress"><![CDATA[Saving...]]></xsl:variable>

<!-- *** Template to sanitize UAR i18n messages *** -->
<xsl:template name="sanitize_uar_i18n_message">{{sanitize_uar_i18n_message}}</xsl:template>

<!-- *** UAR v2, Expert Search - Template to include the localized messages
         for UAR and Expert Search component. *** -->
<xsl:template name="include_localized_messages_for_uar_expert_search">{{include_localized_messages_for_uar_expert_search}}</xsl:template>

<!-- *** UAR v2 - Template to include the JavaScript required for the UAR UI
         component. *** -->
<xsl:template name="include_uar_ui_component">{{include_uar_ui_component}}</xsl:template>

<!-- *** Template to populate the i18n message array which is used by uar.js *** -->
<xsl:template name="populate_uar_i18n_array">{{populate_uar_i18n_array}}</xsl:template>

<!-- *** Previewer i18n messages *** -->
<xsl:variable name="msg_previewer_error"><![CDATA[Transformation error]]></xsl:variable>
<xsl:variable name="msg_previewer_connecting"><![CDATA[Connecting]]></xsl:variable>
<xsl:variable name="msg_previewer_document_too_large"><![CDATA[Document too large]]></xsl:variable>
<xsl:variable name="msg_previewer_hit_page"><![CDATA[Hit page]]></xsl:variable>
<xsl:variable name="msg_previewer_initializing"><![CDATA[Initializing]]></xsl:variable>
<xsl:variable name="msg_previewer_page"><![CDATA[Page]]></xsl:variable>
<xsl:variable name="msg_previewer_pending"><![CDATA[Pending]]></xsl:variable>
<xsl:variable name="msg_previewer_preview_unavailable"><![CDATA[Preview unavailable]]></xsl:variable>



<!-- *** Template to populate the i18n message array which is used by floating previewer widget *** -->
<xsl:template name="populate_previewer_i18n_array">{{populate_previewer_i18n_array}}</xsl:template>

<!-- **********************************************************************
 My global page header/footer (can be customized)
     ********************************************************************** -->
<xsl:template name="my_page_header">{{my_page_header}}</xsl:template>

<xsl:template name="my_page_footer">{{my_page_footer}}</xsl:template>

<!-- *** showing up serve-logs in footer *** -->
<xsl:template match="TraceNode">
  <table>
    Total time taken : <span style='font-style: italics;' id='total_time'><xsl:value-of select="(@out-time - @in-time) div 1000000"/></span>
    <xsl:apply-templates select="Record"/>
  </table>
</xsl:template>

<xsl:template match="Record">
   <tr>
     <td> <xsl:value-of select="Stmt/@log"/> </td>
     <td> <i><xsl:value-of select="@time-from-start"/></i> </td>
   </tr>
</xsl:template>

<!-- **********************************************************************
 Logo template (can be customized)
     ********************************************************************** -->
<xsl:template name="logo">{{logo}}</xsl:template>


<!-- **********************************************************************
 Search result page header (can be customized): logo and search box
     ********************************************************************** -->
<xsl:template name="result_page_header">{{result_page_header}}</xsl:template>


<!-- **********************************************************************
 Search within results page header (can be customized): logo and search box 
     ********************************************************************** -->
<xsl:template name="swr_page_header">{{swr_page_header}}</xsl:template>


<!-- **********************************************************************
 Home search page header (can be customized): logo and search box
     ********************************************************************** -->
<xsl:template name="home_page_header">{{home_page_header}}</xsl:template>


<!-- **********************************************************************
 Separation bar variables (used in advanced search header and result page)
     ********************************************************************** -->
<xsl:variable name="sep_bar_border_color">
  <xsl:choose>
    <xsl:when test="$choose_sep_bar = 'ltblue'">#3366cc</xsl:when>
    <xsl:when test="$choose_sep_bar = 'blue'">#3366cc</xsl:when>
    <xsl:otherwise><xsl:value-of select="$global_bg_color"/></xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="sep_bar_bg_color">
  <xsl:choose>
    <xsl:when test="$is_embedded_mode = '1'">#efefef</xsl:when>
    <xsl:when test="$choose_sep_bar = 'ltblue'">#e5ecf9</xsl:when>
    <xsl:when test="$choose_sep_bar = 'blue'">#3366cc</xsl:when>
    <xsl:otherwise><xsl:value-of select="$global_bg_color"/></xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="sep_bar_text_color">
  <xsl:choose>
    <xsl:when test="$choose_sep_bar = 'ltblue'">#000000</xsl:when>
    <xsl:when test="$choose_sep_bar = 'blue'">#ffffff</xsl:when>
    <xsl:otherwise><xsl:value-of select="$global_text_color"/></xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- **********************************************************************
 Advanced search page header HTML (can be customized)
     ********************************************************************** -->
<xsl:template name="advanced_search_header">{{advanced_search_header}}</xsl:template>


<!-- **********************************************************************
 Cached page header (can be customized)
     ********************************************************************** -->
<xsl:template name="cached_page_header">{{cached_page_header}}</xsl:template>

<!-- **********************************************************************
 Suggest service javascript (do not customize)
     ********************************************************************** -->
<xsl:template name="gsa_suggest">{{gsa_suggest}}</xsl:template>


<!-- **********************************************************************
 "Search Within Results" search input page (can be customized)
     ********************************************************************** -->
<xsl:template name="swr_search">{{swr_search}}</xsl:template>


<!-- **********************************************************************
 "Front door" search input page (can be customized)
     ********************************************************************** -->
<xsl:template name="front_door">{{front_door}}</xsl:template>


<!-- **********************************************************************
 Empty result set (can be customized)
     ********************************************************************** -->
<xsl:template name="no_RES">{{no_RES}}</xsl:template>


<!-- ######################################################################
 We do not recommend changes to the following code.  Google Technical
 Support Personnel currently do not support customization of XSLT under
 these Technical Support Services Guidelines.  Such services may be
 provided on a consulting basis, at Google's then-current consulting
 services rates under a separate agreement, if Google personnel are
 available.  Please ask your Google Account Manager for more details if
 you are interested in purchasing consulting services.
     ###################################################################### -->


<!-- **********************************************************************
 Global Style (do not customize)
        default font type/size/color, background color, link color
         using HTML CSS (Cascading Style Sheets)
     ********************************************************************** -->
<xsl:template name="style">{{style}}</xsl:template>

<!-- **********************************************************************
 URL variables (do not customize)
     ********************************************************************** -->
<!-- *** if this is a test search (help variable)-->
<xsl:variable name="is_test_search"
  select="/GSP/PARAM[@name='testSearch']/@value"/>

<!-- *** if this is a search within results search *** -->
<xsl:variable name="swrnum">
  <xsl:choose>
    <xsl:when test="/GSP/PARAM[(@name='swrnum') and (@value!='')]">
      <xsl:value-of select="/GSP/PARAM[@name='swrnum']/@value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="0"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- *** help_url: search tip URL (html file) *** -->
<xsl:variable name="help_url">/user_help.html</xsl:variable>

<!-- *** base_url: collection info *** -->
<xsl:variable name="base_url">
  <xsl:for-each
    select="/GSP/PARAM[@name = 'client' or

                     @name = 'site' or
                     @name = 'num' or
                     @name = 'output' or
                     @name = 'proxystylesheet' or
                     @name = 'access' or
                     @name = 'lr' or
                     @name = 'ie']">
    <xsl:value-of select="@name"/>=<xsl:value-of select="@original_value"/>
    <xsl:if test="position() != last()">&amp;</xsl:if>
  </xsl:for-each>
</xsl:variable>

<!-- *** home_url: search? + collection info + &proxycustom=<HOME/> *** -->
<xsl:variable name="home_url">
  <xsl:value-of select="$gsa_search_root_path_prefix"/>?<xsl:value-of select="$base_url"
  />&amp;proxycustom=&lt;HOME/&gt;</xsl:variable>


<!-- *** synonym_url: does not include q, as_q, and start elements *** -->
<xsl:variable name="synonym_url"><xsl:for-each
  select="/GSP/PARAM[(@name != 'q') and
                     (@name != 'as_q') and
                     (@name != 'swrnum') and
                     (@name != 'dnavs') and
                     (@name != $embedded_mode_root_path_param) and
                     (@name != $embedded_mode_resource_root_path_param) and
                     (@name != $embedded_mode_disable_style) and
                     (@name != 'ie') and
                     (@name != 'start') and
                     (@name != 'epoch' or $is_test_search != '') and
                     not(starts-with(@name, 'metabased_'))]">
    <xsl:choose>
      <xsl:when test="@name = 'ip' and $show_ips_in_search_url = '0'">
        <!-- do nothing to remove 'ip' from the URL -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@name"/><xsl:text>=</xsl:text>
        <xsl:value-of select="@original_value"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
      <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<!-- *** search_url *** -->
<xsl:variable name="search_url">
  <!-- Expert Search - ignore expertsearchasync query param. -->
  <xsl:for-each
      select="/GSP/PARAM[(@name != 'start') and
                         (@name != $embedded_mode_root_path_param) and
                         (@name != $embedded_mode_resource_root_path_param) and
                         (@name != $embedded_mode_disable_style) and
                         (@name != 'swrnum') and
                         (@name != 'expertsearchasync') and
                         (@name != 'epoch' or $is_test_search != '') and
                         not(starts-with(@name, 'metabased_'))]">
    <xsl:choose>
      <xsl:when test="@name = 'ip' and $show_ips_in_search_url = '0'">
        <!-- do nothing to remove 'ip' from the URL -->
      </xsl:when>
      <xsl:when test="@name = 'only_apps' and $show_apps_segmented_ui = '1'">
        <xsl:value-of select="'exclude_apps=1'" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@name"/><xsl:text>=</xsl:text>
        <xsl:value-of select="@original_value"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
      <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<!-- *** search_url minus any dynamic navigation filters *** -->
<xsl:variable name="search_url_no_dnavs">
  <xsl:for-each
      select="/GSP/PARAM[(@name != 'start') and
                         (@name != $embedded_mode_root_path_param) and
                         (@name != $embedded_mode_resource_root_path_param) and
                         (@name != $embedded_mode_disable_style) and
                         (@name != 'swrnum') and
                         (@name != 'dnavs') and
                         (@name != 'epoch' or $is_test_search != '') and
                         not(starts-with(@name, 'metabased_'))]">
    <xsl:choose>
      <xsl:when test="@name = 'ip' and $show_ips_in_search_url = '0'">
        <!-- do nothing to remove 'ip' from the URL -->
      </xsl:when>
      <xsl:when test="@name = 'only_apps' and $show_apps_segmented_ui = '1'">
        <xsl:value-of select="'exclude_apps=1'" />
      </xsl:when>
      <xsl:when test="@name = 'q' and /GSP/PARAM[@name='dnavs']">
        <xsl:value-of select="@name"/><xsl:text>=</xsl:text>
        <xsl:value-of select="substring-before(@original_value,
          concat('+', /GSP/PARAM[@name='dnavs']/@original_value))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@name"/><xsl:text>=</xsl:text>
        <xsl:value-of select="@original_value"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
      <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<!-- *** url without q and dnavs param *** -->
<xsl:variable name="no_q_dnavs_params">
  <xsl:for-each
      select="/GSP/PARAM[(@name != 'start') and
                         (@name != $embedded_mode_root_path_param) and
                         (@name != $embedded_mode_resource_root_path_param) and
                         (@name != $embedded_mode_disable_style) and
                         (@name != 'swrnum') and
                         (@name != 'q') and
                         (@name != 'dnavs') and
                         (@name != 'epoch' or $is_test_search != '') and
                         not(starts-with(@name, 'metabased_'))]">
    <xsl:choose>
      <xsl:when test="@name = 'ip' and $show_ips_in_search_url = '0'">
        <!-- do nothing to remove 'ip' from the URL -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@name"/><xsl:text>=</xsl:text>
        <xsl:value-of select="@original_value"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
      <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

 <!-- *** no_q_dnavs_params_escaped: safe for inclusion in javascript *** -->
<xsl:variable name="no_q_dnavs_params_escaped">
  <xsl:call-template name="js_escape">
    <xsl:with-param name="string" select="$no_q_dnavs_params"/>
    <xsl:with-param name="slash_mode" select='"0"'/>
  </xsl:call-template>
</xsl:variable>

 <!-- *** search_url_escaped: safe for inclusion in javascript *** -->
<xsl:variable name="search_url_escaped">
  <xsl:call-template name="js_escape">
    <xsl:with-param name="string" select="$search_url_no_dnavs"/>
    <xsl:with-param name="slash_mode" select='"0"'/>
  </xsl:call-template>
</xsl:variable>

<!-- *** filter_url: everything except resetting "filter=" *** -->
<xsl:variable name="filter_url"><xsl:value-of
    select="$gsa_search_root_path_prefix"/>?<xsl:for-each
    select="/GSP/PARAM[(@name != 'filter') and
                       (@name != $embedded_mode_root_path_param) and
                       (@name != $embedded_mode_resource_root_path_param) and
                       (@name != $embedded_mode_disable_style) and
                       (@name != 'epoch' or $is_test_search != '') and
                       not(starts-with(@name, 'metabased_'))]">
    <xsl:choose>
      <xsl:when test="@name = 'ip' and $show_ips_in_search_url = '0'">
        <!-- do nothing to remove 'ip' from the URL -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@name"/><xsl:text>=</xsl:text>
        <xsl:value-of select="@original_value"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
      <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
    </xsl:if>
  </xsl:for-each>
  <xsl:text disable-output-escaping='yes'>&amp;filter=</xsl:text>
</xsl:variable>

<!-- *** adv_search_url: search? + $search_url + as_q=$q *** -->
<xsl:variable name="adv_search_url"><xsl:value-of
    select="$gsa_search_root_path_prefix"/>?<xsl:value-of
    select="$search_url_no_dnavs"/>&amp;proxycustom=&lt;ADVANCED/&gt;</xsl:variable>

<!-- *** exclude_apps: stores the value of exclude_apps query string argument,
      if present. A value of '1' indicates that segmented UI should be
      displayed. Value of '0' indicates that normal blended results UI should be
      displayed. -->
<xsl:variable name="exclude_apps">
  <xsl:choose>
    <xsl:when test="/GSP/PARAM[@name='exclude_apps']">
      <xsl:value-of select="/GSP/PARAM[@name='exclude_apps']/@original_value" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'1'" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- *** only_apps: A value of '1' indicates returning only Google Apps
     results. -->
<xsl:variable name="only_apps">
  <xsl:value-of select="/GSP/PARAM[@name='only_apps']/@original_value"/>
</xsl:variable>

<!-- *** db_url_protocol: googledb:// *** -->
<xsl:variable name="db_url_protocol">googledb://</xsl:variable>

<!-- *** googleconnector_protocol: googleconnector:// *** -->
<xsl:variable name="googleconnector_protocol">googleconnector://</xsl:variable>

<!-- *** dbconnector_protocol: dbconnector:// *** -->
<xsl:variable name="dbconnector_protocol">dbconnector://</xsl:variable>

<!-- *** nfs_url_protocol: nfs:// *** -->
<xsl:variable name="nfs_url_protocol">nfs://</xsl:variable>

<!-- *** smb_url_protocol: smb:// *** -->
<xsl:variable name="smb_url_protocol">smb://</xsl:variable>

<!-- *** unc_url_protocol: unc:// *** -->
<xsl:variable name="unc_url_protocol">unc://</xsl:variable>

<!-- *** swr_search_url: search? + $search_url + as_q=$q *** -->
<!-- for secure search no estimates are available(except if Customer enabled them
so we use a sentinel value of -1 for swrnum -->
<xsl:variable name="swr_search_url"><xsl:value-of
    select="$gsa_search_root_path_prefix"/>?<xsl:value-of
    select="$search_url_no_dnavs"/>&amp;swrnum=<xsl:choose>
    <xsl:when test="((($access = 'a') or ($access = 's')) and /GSP/RES/M = '')">
      <xsl:value-of select="-1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="/GSP/RES/M"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- *** analytics_script_url: https://www.google-analytics.com/ga.js *** -->
<xsl:variable
  name="analytics_script_url">https://www.google-analytics.com/ga.js</xsl:variable>

<!-- **********************************************************************
 Search Parameters (do not customize)
     ********************************************************************** -->

<!-- *** num_results: actual num_results per page *** -->
<xsl:variable name="num_results">
  <xsl:choose>
    <xsl:when test="/GSP/PARAM[(@name='num') and (@value!='')]">
      <xsl:value-of select="/GSP/PARAM[@name='num']/@value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="10"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- *** form_params: parameters carried by the search input form *** -->
<xsl:template name="form_params">{{form_params}}</xsl:template>

<!-- *** original query without any dynamic navigation filters *** -->
<xsl:variable name="qval">
  <xsl:choose>
    <xsl:when test="/GSP/PARAM[@name='dnavs']">
      <xsl:value-of select="concat(substring-before(/GSP/Q,
        /GSP/PARAM[@name='dnavs']/@value), ' ', substring-after(/GSP/Q,
        /GSP/PARAM[@name='dnavs']/@value))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="/GSP/Q"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="original_q">
  <xsl:choose>
    <xsl:when test="count(/GSP/PARAM[@name='dnavs']) > 0">
      <xsl:value-of
        select="substring-before(/GSP/PARAM[@name='q']/@original_value,
        concat('+', /GSP/PARAM[@name='dnavs']/@original_value))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="/GSP/PARAM[@name='q']/@original_value"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- *** space_normalized_query: q = /GSP/Q *** -->
<xsl:variable name="space_normalized_query">
  <xsl:value-of select="normalize-space($qval)"
    disable-output-escaping="yes"/>
</xsl:variable>

<!-- *** stripped_search_query: q, as_q, ... for cache highlight *** -->
<xsl:variable name="stripped_search_query"><xsl:for-each
  select="/GSP/PARAM[(@name = 'q') or
                     (@name = 'as_q') or
                     (@name = 'as_oq') or
                     (@name = 'as_epq')]"><xsl:value-of select="@original_value"
  /><xsl:if test="position() != last()"
    ><xsl:text disable-output-escaping="yes">+</xsl:text
     ></xsl:if></xsl:for-each>
</xsl:variable>

<xsl:variable name="access">
  <xsl:choose>
    <xsl:when test="/GSP/PARAM[(@name='access') and ((@value='s') or (@value='a'))]">
      <xsl:value-of select="/GSP/PARAM[@name='access']/@original_value"/>
    </xsl:when>
    <xsl:otherwise>p</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- **********************************************************************
 Script to get current page.
     ********************************************************************** -->
<xsl:template name="search_home_script">{{search_home_script}}</xsl:template>

<!-- **********************************************************************
 Shown sign-in/sign-out links at the top of the /search page
     ********************************************************************** -->

<xsl:template name="sign_in">{{sign_in}}</xsl:template>

<xsl:template name="signed_in">{{signed_in}}</xsl:template>

<xsl:template name="personalization">{{personalization}}</xsl:template>

<xsl:template name="doc_type">{{doc_type}}</xsl:template>

<!-- **********************************************************************
 Figure out what kind of page this is (do not customize)
     ********************************************************************** -->
<xsl:template match="GSP">
  <xsl:choose>
    <!-- Expert Search - return the expert search results for widget view
         if the current query is for the same. -->
    <xsl:when test="$show_expert_search_widget_view_results = '1'">
      <xsl:call-template name="render_expert_search_results">
        <xsl:with-param name="src_prefix"
            select="concat($gsa_search_root_path_prefix, '?')" />
        <xsl:with-param name="current_search_query_args"
            select="$search_url" />
        <xsl:with-param name="msg_expert_search_no_experts_found"
            select="$msg_expert_search_no_experts_found" />
        <xsl:with-param name="msg_expert_search_switch_to_expanded_mode"
            select="$msg_expert_search_switch_to_expanded_mode" />
        <xsl:with-param name="msg_results_page_number_prefix"
            select="$msg_results_page_number_prefix" />
        <xsl:with-param name="msg_go_to_previous_page"
            select="$msg_go_to_previous_page" />
        <xsl:with-param name="msg_go_to_next_page"
            select="$msg_go_to_next_page" />
        <xsl:with-param name="msg_previous_page_action"
            select="$msg_previous_page_action" />
        <xsl:with-param name="msg_next_page_action"
            select="$msg_next_page_action" />
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$only_apps = '1' and $show_apps_segmented_ui = '1'">
      <xsl:call-template name="apps_only_search_results"/>
    </xsl:when>
    <xsl:when test="Q">
      <xsl:choose>
        <xsl:when test="($swrnum != 0) or
          (($swrnum = '-1') and (($access = 'a') or ($access = 's')))">
          <xsl:call-template name="swr_search"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="search_results"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="CACHE">
      <xsl:choose>
        <xsl:when test="$show_res_cache!='0'">
          <xsl:call-template name="cached_page"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="no_RES"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="CUSTOM/HOME">
      <xsl:call-template name="front_door"/>
    </xsl:when>
    <xsl:when test="CUSTOM/ADVANCED">
      <xsl:call-template name="advanced_search"/>
    </xsl:when>
    <xsl:when test="ERROR">
      <xsl:call-template name="error_page">
        <xsl:with-param name="errorMessage" select="$server_error_msg_text"/>
        <xsl:with-param name="errorDescription" select="$server_error_des_text"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_page">
        <xsl:with-param name="errorMessage" select="$xml_error_msg_text"/>
        <xsl:with-param name="errorDescription" select="$xml_error_des_text"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- **********************************************************************
 Cached page (do not customize)
     ********************************************************************** -->
<xsl:template name="cached_page">{{cached_page}}</xsl:template>

<xsl:template name="escape_quot">{{escape_quot}}</xsl:template>

<!-- Escapes single quote, double quotes, < and > characters. -->
<xsl:template name="js_escape">{{js_escape}}</xsl:template>

<!-- **********************************************************************
 Advanced search page (do not customize)
     ********************************************************************** -->
<xsl:template name="advanced_search">{{advanced_search}}</xsl:template>

<!-- **********************************************************************
 Resend query with filter=p to disable path_filtering
 if there is only one result cluster (do not customize)
     ********************************************************************** -->
<xsl:template name="redirect_if_few_results">{{redirect_if_few_results}}</xsl:template>

<!-- **********************************************************************
 Google Apps search results (do not customize)
     ********************************************************************** -->
<xsl:template name="apps_only_search_results">{{apps_only_search_results}}</xsl:template>

<!-- **********************************************************************
 Search results (do not customize)
     ********************************************************************** -->
<xsl:template name="search_results">{{search_results}}</xsl:template>

<xsl:template name="search_results_body">{{search_results_body}}</xsl:template>


<!-- **********************************************************************
  Collection menu beside the search box
     ********************************************************************** -->
<xsl:template name="collection_menu">{{collection_menu}}</xsl:template>

<!-- **********************************************************************
  Search box input form (Types: std_top, std_bottom, home, swr)
     ********************************************************************** -->
<xsl:template name="search_box">{{search_box}}</xsl:template>


<!-- **********************************************************************
  Bottom search box (do not customized)
     ********************************************************************** -->
<xsl:template name="bottom_search_box">{{bottom_search_box}}</xsl:template>


<!-- **********************************************************************
 Sort-by criteria: sort by date/relevance
     ********************************************************************** -->
<xsl:template name="sort_by">{{sort_by}}</xsl:template>

<xsl:template name="cluster_results">{{cluster_results}}</xsl:template>

<!-- Generates search results navigation bar to be placed at the top. -->
<xsl:template name="gen_top_navigation">{{gen_top_navigation}}</xsl:template>

<!-- Generates search results navigation bar to be placed at the bottom. -->
<xsl:template name="gen_bottom_navigation">{{gen_bottom_navigation}}</xsl:template>

<!-- **********************************************************************
 Output all results
     ********************************************************************** -->
<xsl:template name="results">{{results}}</xsl:template>

<xsl:template name="dynamic_navigation_results">{{dynamic_navigation_results}}</xsl:template>

<!-- This template is specifically needed to hide the lag in rendering for the
     dynamic navigation attributes with large set of values. Since only the top
     few values need to be displayed, the rest are added to the dynNavMgr JS
     instance for rendering later on demand ('More' click).
-->
<xsl:template match="PMT" mode="hidden">
  <xsl:if test="@IR != 1">
    <xsl:variable name="values">
      [<xsl:for-each select="PV[position() &gt; $dyn_nav_max_rows and @C != '0']">["<xsl:call-template
          name='js_escape'><xsl:with-param name="string"
          select="@V"/><xsl:with-param name="slash_mode" select='"1"'/>
          </xsl:call-template>", <xsl:value-of select='@C'/>]<xsl:if
          test="position() != last()">,</xsl:if></xsl:for-each>]
    </xsl:variable>
    <xsl:variable name="attr_id"><xsl:value-of
        select="concat('attr_', string(position()))"/></xsl:variable>

    dynNavMgr.addAttrValues("<xsl:value-of select='$attr_id'/>", <xsl:value-of select='$values'/>);
  </xsl:if>
</xsl:template>

<xsl:template match="PMT">
  <xsl:param name="dn_tokens"/>
  <xsl:param name="partial_count"/>

  <xsl:variable name="name"><xsl:value-of select="normalize-space(@NM)"/></xsl:variable>
  <xsl:variable name="pmt_name"><xsl:call-template
      name="term-escape"><xsl:with-param name="val" select="@NM"/></xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@IR = 1">
      <ul class="dn-attr">
        <li class="dn-attr-hdr"><span class="dn-attr-hdr-txt"><xsl:attribute
            name="title"><xsl:value-of select="@DN" disable-output-escaping="yes"/>
        </xsl:attribute><xsl:value-of select="@DN"/></span></li>
        <xsl:apply-templates select="PV">
          <xsl:with-param name="pmt_name" select="$pmt_name"/>
          <xsl:with-param name="dn_tokens" select="$dn_tokens"/>
          <xsl:with-param name="partial_count" select="$partial_count"/>
        </xsl:apply-templates>
      </ul>
    </xsl:when>

    <xsl:otherwise>
      <xsl:variable name="total" select="count(PV[@C != '0'])"/>
      <xsl:variable name="attr_class">
        <xsl:choose>
          <xsl:when test="$total &lt; $dyn_nav_max_rows + 1">
            <xsl:value-of select="'dn-attr'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'dn-attr dn-attr-more'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="attr_id"><xsl:value-of
          select="concat('attr_', string(position()))"/></xsl:variable>
      <ul id="{$attr_id}" class="{$attr_class}">
        <xsl:choose>
          <xsl:when test="$total &lt; $dyn_nav_max_rows + 1">
            <li class="dn-attr-hdr"><span class="dn-attr-hdr-txt"><xsl:attribute
              name="title"><xsl:value-of select="@DN" disable-output-escaping="yes"/>
            </xsl:attribute><xsl:value-of select="@DN"/></span></li>
          </xsl:when>
          <xsl:otherwise>
            <li class="dn-attr-hdr"><div class="dn-zippy-hdr"><div class="dn-zippy-hdr-img"></div>
              <span class="dn-attr-hdr-txt"><xsl:attribute
                name="title"><xsl:value-of select="@DN" disable-output-escaping="yes"/>
              </xsl:attribute><xsl:value-of select="@DN"/></span></div></li>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:apply-templates select="PV[position() &lt; $dyn_nav_max_rows + 1]">
          <xsl:with-param name="pmt_name" select="$pmt_name"/>
          <xsl:with-param name="header" select="@DN"/>
          <xsl:with-param name="dn_tokens" select="$dn_tokens"/>
          <xsl:with-param name="partial_count" select="$partial_count"/>
        </xsl:apply-templates>

        <xsl:if test="$total &gt; $dyn_nav_max_rows">
          <xsl:variable name="total_left" select="$total - $dyn_nav_max_rows"/>
          <li id="{$attr_id}_more_less">
            <a id="more_{$attr_id}" class="dn-link" style="margin-right: 10px; outline-style: none;"
              onclick="dynNavMgr.displayMore('{$attr_id}', true); return false;"
              href="javascript:;">
              <xsl:attribute name="ctype">
                  <xsl:text>dynnav.</xsl:text>
                  <xsl:value-of select="$name" disable-output-escaping="no"/>
                  <xsl:text>.more</xsl:text>
              </xsl:attribute>
              <span class="dn-more-img dn-mimg"></span>
              <span id="disp_{$attr_id}"><xsl:value-of
              select="$total_left"/></span><span> More</span>
            </a>
            <a id="less_{$attr_id}" class="dn-link dn-hidden" style="outline-style: none;"
              onclick="dynNavMgr.displayMore('{$attr_id}', false, {$total_left}); return false;"
              href="javascript:;">
              <xsl:attribute name="ctype">
                <xsl:text>dynnav.</xsl:text>
                <xsl:value-of select="$name" disable-output-escaping="no"/>
                <xsl:text>.less</xsl:text>
              </xsl:attribute>
              <span class="dn-more-img dn-limg"></span>
              <span>Less</span>
            </a>
          </li>
          <label class="dn-hidden dn-id"><xsl:value-of select="$attr_id"/></label>
          <label id="{$attr_id}_escaped" class="dn-hidden"><xsl:value-of
              select="$pmt_name"/></label>
          <label id="{$attr_id}_total" class="dn-hidden"><xsl:value-of
              select="$total"/></label>
          <label id="{$attr_id}_total_left" class="dn-hidden"><xsl:value-of
              select="$total_left"/></label>
        </xsl:if>
      </ul>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="PV">
  <xsl:param name="pmt_name"/>
  <xsl:param name="header"/>
  <xsl:param name="dn_tokens"/>
  <xsl:param name="partial_count"/>

  <xsl:if test="@C != 0">
    <xsl:apply-templates select="." mode="construct">
      <xsl:with-param name="dn_tokens" select="$dn_tokens"/>
      <xsl:with-param name="header" select="$header"/>
      <xsl:with-param name="partial_count" select="$partial_count"/>
      <xsl:with-param name="current_token">
        <xsl:choose>
          <xsl:when test="../@IR = '1'"><xsl:variable
            name="stripped_l" select="normalize-space(@L)"/><xsl:variable
            name="stripped_h" select="normalize-space(@H)"/>inmeta:<xsl:value-of
            select="$pmt_name"/>:<xsl:choose><xsl:when test="../@T = 3"><xsl:if
            test="$stripped_l != ''">$<xsl:value-of select="$stripped_l"/></xsl:if>..<xsl:if
            test="$stripped_h != ''">$<xsl:value-of
            select="$stripped_h"/></xsl:if></xsl:when><xsl:otherwise><xsl:value-of
            select="$stripped_l"/>..<xsl:value-of select="$stripped_h"/></xsl:otherwise></xsl:choose>
          </xsl:when>
          <xsl:otherwise>inmeta:<xsl:value-of select="$pmt_name"/>%3D<xsl:call-template
              name="term-escape"><xsl:with-param name="val"
              select="@V"/></xsl:call-template></xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template match="PV" mode="construct">
  <xsl:param name="dn_tokens"/>
  <xsl:param name="header"/>
  <xsl:param name="current_token"/>
  <xsl:param name="partial_count"/>

  <xsl:variable name="dispval">
    <xsl:apply-templates select="." mode="display_value">
      <xsl:with-param name="js_escape" select="'1'"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:variable name="dispcount">
    <xsl:text>(</xsl:text><xsl:if
       test="$partial_count=1"><xsl:text>&gt; </xsl:text></xsl:if>
      <xsl:value-of select="@C"/><xsl:text>)</xsl:text>
  </xsl:variable>

  <xsl:variable name="is_selected" select="index-of($dn_tokens, $current_token)"/>
  <li class="dn-attr-v">
    <xsl:choose>
      <xsl:when test="exists($is_selected)">
        <xsl:variable name="other_tokens">
          <xsl:value-of select="string-join(remove($dn_tokens, $is_selected[position()=1]), '+')"/>
        </xsl:variable>

        <xsl:variable name="cancel_url">
          <xsl:value-of select="$no_q_dnavs_params"/>&amp;q=<xsl:value-of
            select="$original_q"/><xsl:if test="$other_tokens != ''">+<xsl:value-of
            select="$other_tokens"/>&amp;dnavs=<xsl:value-of select="$other_tokens"/></xsl:if>
        </xsl:variable>

        <a class="dn-img dn-r-img"
            href="{$gsa_search_root_path_prefix}?{$cancel_url}"
            title="Clear">
          <xsl:attribute name="ctype">
            <xsl:text>dynnav.clear.</xsl:text>
            <xsl:value-of select="$header" disable-output-escaping="no"/>
          </xsl:attribute>
        </a>
        <span class="dn-overflow dn-inline-block" style="width: 86%;">
          <xsl:if test="../@IR != 1">
            <xsl:attribute name="title"><xsl:value-of select="$dispval"
                disable-output-escaping="yes"/></xsl:attribute>
          </xsl:if>
          <div class="dn-attr-txt"><xsl:value-of
              select="$dispval" disable-output-escaping="yes"/>
          </div>
          <span><xsl:value-of
              select="$dispcount" disable-output-escaping="yes"/>
          </span>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="pmts_var">dnavs=<xsl:if test="/GSP/PARAM[@name='dnavs']"><xsl:value-of
            select="/GSP/PARAM[@name='dnavs']/@original_value"/>+</xsl:if><xsl:value-of
            select="$current_token"/>
        </xsl:variable>
        <xsl:variable name="qurl"><xsl:value-of select="$no_q_dnavs_params"/>&amp;q=<xsl:value-of
            select="/GSP/PARAM[@name='q']/@original_value"/>+<xsl:value-of
            select="$current_token"/>&amp;<xsl:value-of select="$pmts_var"/>
        </xsl:variable>
        <div class="dn-attr-txt"><a
          class="dn-attr-a" href="{$gsa_search_root_path_prefix}?{$qurl}">
          <xsl:attribute name="ctype">
            <xsl:text>dynnav.</xsl:text>
            <xsl:value-of select="$header" disable-output-escaping="no"/>
            <xsl:text>.</xsl:text>
            <xsl:value-of select="$dispval" disable-output-escaping="no"/>
          </xsl:attribute>
          <xsl:if test="../@IR != 1">
            <xsl:attribute name="title"><xsl:value-of select="$dispval"
                disable-output-escaping="no"/></xsl:attribute>
          </xsl:if><xsl:value-of
              select="$dispval" disable-output-escaping="yes"/></a>
        </div>
        <span class="dn-attr-c"><xsl:value-of select="$dispcount"
            disable-output-escaping="yes"/></span>
      </xsl:otherwise>
    </xsl:choose>
  </li>
</xsl:template>

<xsl:template match="PV" mode="display_value">
  <xsl:param name="js_escape"/>
  <xsl:choose>
    <xsl:when test="../@IR = 1">
      <xsl:variable name="disp_l">
        <xsl:call-template name="pmt_range_display_val">
          <xsl:with-param name="val" select="@L"/>
          <xsl:with-param name="type" select="../@T"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="disp_h">
        <xsl:call-template name="pmt_range_display_val">
          <xsl:with-param name="val" select="@H"/>
          <xsl:with-param name="type" select="../@T"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$disp_l = ''">
          <xsl:value-of select="$disp_h"/><xsl:text> </xsl:text>
          <xsl:choose>
            <xsl:when test="../@T = 4">or earlier</xsl:when>
            <xsl:otherwise>or less</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$disp_h = ''">
          <xsl:value-of select="$disp_l"/><xsl:text> </xsl:text>
          <xsl:choose>
            <xsl:when test="../@T = 4">or later</xsl:when>
            <xsl:otherwise>or more</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise><xsl:value-of
          select="$disp_l"/><xsl:text> </xsl:text><xsl:call-template
          name="endash"/><xsl:text> </xsl:text><xsl:value-of select="$disp_h"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$js_escape = '1'">
          <xsl:call-template name="js_escape"><xsl:with-param name="string"
            select="@V"/><xsl:with-param name="slash_mode" select='"0"'/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="@V"/></xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:variable name="hex">0123456789ABCDEF</xsl:variable>
<xsl:template name="term-escape">{{term-escape}}</xsl:template>

<xsl:template name="pmt_range_display_val">{{pmt_range_display_val}}</xsl:template>

<xsl:template name="main_results">{{main_results}}</xsl:template>

<xsl:template name="render_main_results">{{render_main_results}}</xsl:template>

<!-- **********************************************************************
 Stopwords suggestions in result page (do not customize)
     ********************************************************************** -->
<xsl:template name="stopwords">{{stopwords}}</xsl:template>


<!-- **********************************************************************
 Spelling suggestions in result page (do not customize)
     ********************************************************************** -->
<xsl:template name="spelling">{{spelling}}</xsl:template>


<!-- **********************************************************************
 Synonym suggestions in result page (do not customize)
     ********************************************************************** -->
<xsl:template name="synonyms">{{synonyms}}</xsl:template>


<!-- **********************************************************************
 Truncation functions (do not customize)
     ********************************************************************** -->
<xsl:template name="truncate_url">{{truncate_url}}</xsl:template>

<xsl:template name="truncate_find_last_token">{{truncate_find_last_token}}</xsl:template>

<xsl:template name="truncate_chop_path">{{truncate_chop_path}}</xsl:template>


<!-- **********************************************************************
  Google Apps (do not customize)
     ********************************************************************** -->
<xsl:variable
  name="sites_icon"
  select="'https://www.google.com/sites/images/sites_favicon.ico'"/>
<xsl:variable
  name="docs_icon"
  select="'https://docs.google.com/images/doclist/icon_doc.gif'"/>
<xsl:variable
  name="spreadsheets_icon"
  select="'https://docs.google.com/images/doclist/icon_spread.gif'"/>
<xsl:variable
  name="presentations_icon"
  select="'https://docs.google.com/images/doclist/icon_pres.gif'"/>
<xsl:variable
  name="pdf_icon"
  select="'https://docs.google.com/images/doclist/icon_6_pdf.gif'"/>
<xsl:variable
  name="drawing_icon"
  select="'https://docs.google.com/images/doclist/icon_6_drawing.png'"/>
<xsl:variable
  name="email_icon"
  select="'https://mail.google.com/mail/images/favicon.ico'"/>

<!-- **********************************************************************
  A single result (do not customize)
     ********************************************************************** -->
<xsl:template match="R">
  <xsl:param name="query"/>

  <xsl:variable name="protocol"     select="substring-before(U, '://')"/>
  <xsl:variable name="temp_url"     select="substring-after(U, '://')"/>
  <xsl:variable name="display_url1" select="substring-after(UD, '://')"/>
  <xsl:variable name="escaped_url"  select="substring-after(UE, '://')"/>

  <xsl:variable name="display_url2">
    <xsl:choose>
      <xsl:when test="$display_url1">
        <xsl:value-of select="$display_url1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$temp_url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="display_url">
    <xsl:choose>
      <xsl:when test="$protocol='unc'">
        <xsl:call-template name="convert_unc">
          <xsl:with-param name="string" select="$display_url2"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$display_url2"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="stripped_url">
    <xsl:choose>
      <xsl:when test="$truncate_result_urls != '0'">
                <xsl:call-template name="truncate_url">
                  <xsl:with-param name="t_url" select="$display_url"/>
                </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
            <xsl:value-of select="$display_url"/>
          </xsl:otherwise>
        </xsl:choose>
  </xsl:variable>

  <xsl:variable name="crowded_url" select="HN/@U"/>
  <xsl:variable name="crowded_display_url1" select="HN"/>
  <xsl:variable name="crowded_display_url">
    <xsl:choose>
      <xsl:when test="$protocol='unc'">
        <xsl:call-template name="convert_unc">
          <xsl:with-param name="string" select="substring-after($crowded_display_url1,'://')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$crowded_display_url1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <xsl:variable name="url_indexed" select="not(starts-with($temp_url, 'noindex!/'))"/>

  <!-- *** Indent as required (only supports 2 levels) *** -->
  <xsl:if test="@L='2'">
    <xsl:text disable-output-escaping="yes">&lt;blockquote class=&quot;g&quot;&gt;</xsl:text>
  </xsl:if>

  <!-- *** Result Header *** -->
  <p class="g">

  <xsl:variable name="apps_domain">
    <xsl:if test="starts-with($stripped_url, 'sites.google.com/a/') or
                  starts-with($stripped_url, 'docs.google.com/a/') or
                  starts-with($stripped_url, 'spreadsheets.google.com/a/')">
      <xsl:value-of
        select="substring-before(substring-after($stripped_url, '/a/'), '/')"/>
    </xsl:if>
  </xsl:variable>

  <!-- *** Google Sites icon *** -->
  <xsl:if test="starts-with($stripped_url, 'sites.google.com/')">
    <img src="{$sites_icon}" alt="" height="16" width="16"/><xsl:call-template name="nbsp"/>
  </xsl:if>

  <!-- *** Google Docs icon *** -->
  <xsl:if test="starts-with($stripped_url, concat('docs.google.com/a/', $apps_domain, '/View?')) or
                RF[@NAME='type']/@VALUE='document'">
    <img src="{$docs_icon}" alt="" height="16" width="16"/><xsl:call-template name="nbsp"/>
  </xsl:if>

  <!-- *** Google Spreadsheets icon *** -->
  <xsl:if test="starts-with($stripped_url, 'spreadsheets.google.com/') or
                 RF[@NAME='type']/@VALUE='spreadsheet'">
    <img src="{$spreadsheets_icon}" alt="" height="16" width="16"/><xsl:call-template name="nbsp"/>
  </xsl:if>

  <!-- *** Google Presentations icon *** -->
  <!-- TODO(timg): remove once Docs eliminates SimplePresentaionView URLs -->
  <xsl:if test="starts-with($stripped_url,
                            concat('docs.google.com/a/', $apps_domain, '/SimplePresentationView?')) or
                starts-with($stripped_url,
                            concat('docs.google.com/a/', $apps_domain, '/PresentationView?')) or
                RF[@NAME='type']/@VALUE='presentation'">
    <img src="{$presentations_icon}" alt="" height="16" width="16"/><xsl:call-template name="nbsp"/>
  </xsl:if>

  <!-- *** Google PDF viewer icon *** -->
  <xsl:if test="RF[@NAME='type']/@VALUE='pdf'">
    <img src="{$pdf_icon}" alt="" height="16" width="16"/><xsl:call-template name="nbsp"/>
  </xsl:if>

  <!-- *** Google Drawing icon *** -->
  <xsl:if test="RF[@NAME='type']/@VALUE='drawing'">
    <img src="{$drawing_icon}" alt="" height="16" width="16"/><xsl:call-template name="nbsp"/>
  </xsl:if>

  <!-- *** GMail icon *** -->
  <xsl:if test="starts-with($stripped_url, 'mail.google.com') or
                RF[@NAME='type']/@VALUE='mail'">
    <img src="{$email_icon}" alt="" height="16" width="16"/>&#xA0;
  </xsl:if>

  <!-- *** Translation button -->
  <xsl:variable name="res_num" select="@N"/>
  <xsl:if test="$show_translation = '1' and $only_apps != '1'">
    <span class="trns-span" id="sec_trns_elem_span_{$res_num}"></span>
  </xsl:if>

  <!-- *** Result Title (including PDF tag and hyperlink) *** -->
  <xsl:if test="$show_res_title != '0'">
    <font size="-2"><b>
    <xsl:choose>
      <xsl:when test="@MIME='text/html' or @MIME='' or not(@MIME)"></xsl:when>
      <xsl:when test="@MIME='text/plain'">[TEXT]</xsl:when>
      <xsl:when test="@MIME='application/rtf'">[RTF]</xsl:when>
      <xsl:when test="@MIME='application/pdf'">[PDF]</xsl:when>
      <xsl:when test="@MIME='application/postscript'">[PS]</xsl:when>
      <xsl:when test="@MIME='application/vnd.ms-powerpoint' or @MIME='application/vnd.openxmlformats-officedocument.presentationml.presentation'">[MS POWERPOINT]</xsl:when>
      <xsl:when test="@MIME='application/vnd.ms-excel' or @MIME='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'">[MS EXCEL]</xsl:when>
      <xsl:when test="@MIME='application/msword' or @MIME='application/vnd.openxmlformats-officedocument.wordprocessingml.document'">[MS WORD]</xsl:when>
      <xsl:otherwise>
        <xsl:variable name="extension">
          <xsl:call-template name="last_substring_after">
            <xsl:with-param name="string" select="substring-after(
                                                  $temp_url,
                                                  '/')"/>
            <xsl:with-param name="separator" select="'.'"/>
            <xsl:with-param name="fallback" select="'UNKNOWN'"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($extension) &lt;= 5">
          [<xsl:value-of select="translate($extension,$lower,$upper)"/>]
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    </b></font>
    <xsl:text> </xsl:text>

    <xsl:variable name="link"
     select="$url_indexed and not(starts-with(U, $googleconnector_protocol))"/>

    <xsl:if test="$link">

      <xsl:text disable-output-escaping='yes'>&lt;a 
            ctype="c"
      </xsl:text>
            rank=&quot;<xsl:value-of select="position()"/>&quot;
      <xsl:text disable-output-escaping='yes'>
            href="</xsl:text>

      <xsl:choose>
        <xsl:when test="starts-with(U, $dbconnector_protocol)">
          <xsl:variable name="cache_encoding">
            <xsl:choose>
              <xsl:when test="'' != HAS/C/@ENC"><xsl:value-of select="HAS/C/@ENC"/></xsl:when>
              <xsl:otherwise>UTF-8</xsl:otherwise>
            </xsl:choose>
            </xsl:variable><xsl:value-of select="$gsa_search_root_path_prefix"/>?q=cache:<xsl:value-of select="HAS/C/@CID"/>:<xsl:value-of select="$stripped_url"/>+<xsl:value-of select="$stripped_search_query"/>&amp;<xsl:value-of select="$base_url"/>&amp;oe=<xsl:value-of select="$cache_encoding"/>
        </xsl:when>

        <xsl:when test="starts-with(U, $db_url_protocol)">
          <xsl:value-of disable-output-escaping='yes'
                        select="concat('db/', $temp_url)"/>
        </xsl:when>
        <!-- *** URI for smb or NFS must be escaped because it appears in the URI query *** -->
        <xsl:when test="$protocol='nfs' or $protocol='smb'">
          <xsl:value-of disable-output-escaping='yes'
                        select="concat($protocol,'/',$temp_url)"/>
        </xsl:when>
        <xsl:when test="$protocol='unc'">
          <xsl:value-of disable-output-escaping='yes' select="concat('file://', $display_url2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of disable-output-escaping='yes' select="U"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text disable-output-escaping='yes'>"&gt;</xsl:text>
    </xsl:if>
    <span id="title_{$res_num}" class="l">
    <xsl:choose>
      <xsl:when test="T">
        <span class= "goog-trans-section l" transId="gadget_{$res_num}">
          <xsl:call-template name="reformat_keyword">
            <xsl:with-param name="orig_string" select="T"/>
          </xsl:call-template>
        </span>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$stripped_url"/></xsl:otherwise>
    </xsl:choose>
    </span>
    <xsl:if test="$link">
        <xsl:text disable-output-escaping='yes'>&lt;/a&gt;</xsl:text>
    </xsl:if>
  </xsl:if>


  <!-- *** Snippet Box *** -->
  <table cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td class="s">
        <xsl:if test="$show_res_snippet != '0' and string-length(S) and
                      $only_apps != '1'">
          <span id="snippet_{$res_num}" class= "goog-trans-section" transId="gadget_{$res_num}">
            <xsl:call-template name="reformat_keyword">
              <xsl:with-param name="orig_string" select="S"/>
            </xsl:call-template>
          </span>
        </xsl:if>

        <!-- *** Meta tags *** -->
        <xsl:if test="$show_meta_tags != '0' and $only_apps != '1'">
          <xsl:apply-templates select="MT"/>
        </xsl:if>

        <xsl:if test="$only_apps != '1' and
                      ($show_res_snippet != '0' and string-length(S)) or
                      ($show_meta_tags != '0' and MT[(@N != '') or (@V != '')])">
        <br/>
        </xsl:if>

        <!-- *** URL *** -->
        <xsl:if test="$only_apps != '1' or
                      ($only_apps = '1' and $show_apps_segmented_ui != '1')">
        <font color="{$res_url_color}" size="{$res_url_size}">
          <xsl:choose>
            <xsl:when test="not($url_indexed)">
              <xsl:if test="($show_res_size!='0') or
                            ($show_res_date!='0') or
                            ($show_res_cache!='0')">
                <xsl:text>Not Indexed:</xsl:text>
                <xsl:value-of select="$stripped_url"/>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="$show_res_url != '0'">
                <xsl:value-of select="$stripped_url"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </font>
        </xsl:if>

        <!-- *** Miscellaneous (- size - date - cache) *** -->
        <xsl:if test="$url_indexed">
        <xsl:choose>
          <xsl:when test="'' != HAS/C/@ENC">
           <xsl:apply-templates select="HAS/C">
                         <xsl:with-param name="stripped_url" select="$stripped_url"/>
                         <xsl:with-param name="escaped_url" select="$escaped_url"/>
                         <xsl:with-param name="query" select="$query"/>
                         <xsl:with-param name="mime" select="@MIME"/>
                         <xsl:with-param name="date" select="FS[@NAME='date']/@VALUE"/>
                         <xsl:with-param name="result_num" select="$res_num"/>
           </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
          <xsl:call-template name="showdate">
              <xsl:with-param name="date" select="FS[@NAME='date']/@VALUE"/>
          </xsl:call-template>
          </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <!-- *** Link to more links from this site *** -->
        <xsl:if test="HN">
          <br/>
          [
          <a ctype="sitesearch" class="f" href="{$gsa_search_root_path_prefix}?as_sitesearch={$crowded_url}&amp;{
            $search_url}">More results from <xsl:value-of select="$crowded_display_url"/></a>
          ]

        <!-- *** Link to aggregated results from database source *** -->
        <xsl:if test="starts-with($crowded_url, $db_url_protocol)">
        [
        <a ctype="db" class="f" href="dbaggr?sitesearch={$crowded_url}&amp;{
          $search_url}&amp;filter=0">View all data</a>
            ]
          </xsl:if>
        </xsl:if>


        <!-- *** Result Footer *** -->
      </td>
    </tr>
  </table>
  </p>

  <!-- *** End indenting as required (only supports 2 levels) *** -->
  <xsl:if test="@L='2'">
    <xsl:text disable-output-escaping="yes">&lt;/blockquote&gt;</xsl:text>
  </xsl:if>

</xsl:template>

<!-- **********************************************************************
  Meta tag values within a result (do not customize)
     ********************************************************************** -->
<xsl:template match="MT">
  <br/>
  <span class="f"><xsl:value-of select="@N"/>: </span><xsl:value-of select="@V"/>
</xsl:template>

<!-- **********************************************************************
  A single keymatch result (do not customize)
     ********************************************************************** -->
<xsl:template match="GM">
  <p>
    <table cellpadding="4" cellspacing="0" border="0" height="40" width="100%">
      <tr>
        <td nowrap="0" bgcolor="{$keymatch_bg_color}" height="40">
          <a ctype="keymatch" href="{GL}">
            <xsl:value-of select="GD"/>
          </a>
          <br/>
          <font size="-1" color="{$res_url_color}">
            <span class="a">
               <xsl:value-of select="GL"/>
            </span>
          </font>
        </td>
        <td bgcolor="{$keymatch_bg_color}" height="40"
          align="right" valign="top">
          <b>
          <font size="-1" color="{$keymatch_text_color}">
            <xsl:value-of select="$keymatch_text"/>
          </font>
          </b>
        </td>
      </tr>
    </table>
  </p>
</xsl:template>


<!-- **********************************************************************
  Variables for reformatting keyword-match display (do not customize)
     ********************************************************************** -->
<xsl:variable name="keyword_orig_start" select="'&lt;b&gt;'"/>
<xsl:variable name="keyword_orig_end" select="'&lt;/b&gt;'"/>

<xsl:variable name="keyword_reformat_start">
  <xsl:if test="$res_keyword_format">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="$res_keyword_format"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:if>
  <xsl:if test="($res_keyword_size) or ($res_keyword_color)">
  <xsl:text>&lt;font</xsl:text>
  <xsl:if test="$res_keyword_size">
    <xsl:text> size="</xsl:text>
    <xsl:value-of select="$res_keyword_size"/>
    <xsl:text>"</xsl:text>
  </xsl:if>
  <xsl:if test="$res_keyword_color">
    <xsl:text> color="</xsl:text>
    <xsl:value-of select="$res_keyword_color"/>
    <xsl:text>"</xsl:text>
  </xsl:if>
  <xsl:text>&gt;</xsl:text>
  </xsl:if>
</xsl:variable>

<xsl:variable name="keyword_reformat_end">
  <xsl:if test="($res_keyword_size) or ($res_keyword_color)">
    <xsl:text>&lt;/font&gt;</xsl:text>
  </xsl:if>
  <xsl:if test="$res_keyword_format">
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="$res_keyword_format"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:if>
</xsl:variable>

<!-- **********************************************************************
  Reformat the keyword match display in a title/snippet string
     (do not customize)
     ********************************************************************** -->
<xsl:template name="reformat_keyword">{{reformat_keyword}}</xsl:template>


<!-- **********************************************************************
  Helper templates for generating a result item (do not customize)
     ********************************************************************** -->

<!-- *** Miscellaneous: - size - date - cache *** -->
<xsl:template match="C">
    <xsl:param name="stripped_url"/>
    <xsl:param name="escaped_url"/>
    <xsl:param name="query"/>
    <xsl:param name="mime"/>
    <xsl:param name="date"/>
    <xsl:param name="result_num"/>

    <xsl:variable name="docid"><xsl:value-of select="@CID"/></xsl:variable>

    <xsl:if test="$show_res_size != '0'">
    <xsl:if test="not(@SZ='')">
        <font color="{$res_url_color}" size="{$res_url_size}">
          <xsl:text> - </xsl:text>
          <xsl:value-of select="@SZ"/>
        </font>
    </xsl:if>
    </xsl:if>

    <xsl:call-template name="showdate">
        <xsl:with-param name="date" select="$date"/>
    </xsl:call-template>

    <xsl:if test="$show_res_cache != '0'">
        <font color="{$res_url_color}" size="{$res_url_size}">
        <xsl:text> - </xsl:text>
        </font>
        <xsl:variable name="cache_encoding">
          <xsl:choose>
            <xsl:when test="'' != @ENC"><xsl:value-of select="@ENC"/></xsl:when>
            <xsl:otherwise>UTF-8</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <a ctype="cache" id="cache_link_{$result_num}" class="f"
              href="{$gsa_search_root_path_prefix}?q=cache:{$docid}:{$escaped_url}+{
                    $stripped_search_query}&amp;{$base_url}&amp;oe={$cache_encoding}">
          <xsl:choose>
            <xsl:when test="not($mime)">Cached</xsl:when>
            <xsl:when test="$mime='text/html'">Cached</xsl:when>
            <xsl:when test="$mime='text/plain'">Cached</xsl:when>
            <xsl:otherwise>Text Version</xsl:otherwise>
          </xsl:choose>
        </a>
        <xsl:if test="$show_translation = '1' and $only_apps != '1'">
          <xsl:call-template name="nbsp3"/>
          <a ctype="cache" id="translate_cache_link_{$result_num}" class="f trns-cache-link"
              href="{$gsa_search_root_path_prefix}?q=cache:{$docid}:{$escaped_url}+{
                   $stripped_search_query}&amp;{$base_url}&amp;oe={$cache_encoding}">Translated
          </a>
        </xsl:if>
    </xsl:if>

</xsl:template>

<xsl:template name="showdate">{{showdate}}</xsl:template>


<!-- **********************************************************************
 Google navigation bar in result page (do not customize)
     ********************************************************************** -->
<xsl:template name="google_navigation">{{google_navigation}}</xsl:template>

<!-- **********************************************************************
 Helper templates for generating Google result navigation (do not customize)
   only shows 10 sets up or down from current view
     ********************************************************************** -->
<xsl:template name="result_nav">{{result_nav}}</xsl:template>


<!-- **********************************************************************
 Top separation bar (do not customize)
     ********************************************************************** -->
<xsl:template name="top_sep_bar">{{top_sep_bar}}</xsl:template>

<!-- **********************************************************************
 Analytics script (do not customize)
     ********************************************************************** -->
<xsl:template name="analytics">{{analytics}}</xsl:template>

<!-- **********************************************************************
 Utility function for constructing copyright text (do not customize)
     ********************************************************************** -->
<xsl:template name="copyright">{{copyright}}</xsl:template>


<!-- **********************************************************************
 Utility functions for generating html entities
     ********************************************************************** -->
<xsl:template name="nbsp">{{nbsp}}</xsl:template>
<xsl:template name="nbsp3">{{nbsp3}}</xsl:template>
<xsl:template name="nbsp4">{{nbsp4}}</xsl:template>
<xsl:template name="quot">{{quot}}</xsl:template>
<xsl:template name="rsaquo">{{rsaquo}}</xsl:template>
<xsl:template name="endash">{{endash}}</xsl:template>
<xsl:template name="copy">{{copy}}</xsl:template>

<!-- **********************************************************************
 Utility functions for generating head elements so that the XSLT processor
 won't add a meta tag to the output, since it may specify the wrong
 encoding (utf8) in the meta tag.
     ********************************************************************** -->
<xsl:template name="plainHeadStart">{{plainHeadStart}}</xsl:template>
<xsl:template name="plainHeadEnd">{{plainHeadEnd}}</xsl:template>


<!-- **********************************************************************
 Utility functions for generating head elements with a meta tag to the output
 specifying the character set as requested
     ********************************************************************** -->
<xsl:template name="langHeadStart">{{langHeadStart}}</xsl:template>

<xsl:template name="langHeadEnd">{{langHeadEnd}}</xsl:template>

<!-- *** Generates the <body> section for the search results page. *** -->
<xsl:template name="generate_html_body_for_search_results">{{generate_html_body_for_search_results}}</xsl:template>

<!-- **********************************************************************
 Utility functions (do not customize)
     ********************************************************************** -->

<!-- *** Find the substring after the last occurence of a separator *** -->
<xsl:template name="last_substring_after">{{last_substring_after}}</xsl:template>

<!-- *** Find and replace *** -->
<xsl:template name="replace_string">{{replace_string}}</xsl:template>

<!-- *** Decode hex encoding *** -->
<xsl:template name="decode_hex">{{decode_hex}}</xsl:template>

<!-- *** Convert UNC *** -->
<xsl:template name="convert_unc">{{convert_unc}}</xsl:template>

<!-- **********************************************************************
 Display error messages
     ********************************************************************** -->
<xsl:template name="error_page">{{error_page}}</xsl:template>


<!-- **********************************************************************
 Google Desktop for Enterprise integration templates
     ********************************************************************** -->
<xsl:template name="desktop_tab">{{desktop_tab}}</xsl:template>

<xsl:template name="desktop_results">{{desktop_results}}</xsl:template>

<!-- **********************************************************************
  OneBox results (if any)
     ********************************************************************** -->
<xsl:template name="onebox">{{onebox}}</xsl:template>

<!-- **********************************************************************
 Swallow unmatched elements
     ********************************************************************** -->
<xsl:template match="@*|node()"/>
</xsl:stylesheet>


<!-- *** END OF STYLESHEET *** -->


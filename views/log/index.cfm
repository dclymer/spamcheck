<cfset addAsset('/includes/js/log/log-controller.js') />
<cfset addAsset('/includes/js/log/lookup-controller.js') />

<cfset prc.containerclasses = 'search-logs' />

<div class="modal fade" id="log-detail-modal" tabindex="-1" role="dialog" aria-labelledby="Log Detail" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
    </div>
  </div>
</div>
<div class="modal fade" id="log-submissions-modal" tabindex="-1" role="dialog" aria-labelledby="Log Submissions" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
    </div>
  </div>
</div>

<cfoutput>

<div id="search-logs">

<div class="container">
	<form method="get" action="#Event.buildLink('log.index')#" class="form-inline" role="form" id="searchlogs">
		<div class="row">
			<div class="span12">
				<input type="hidden" name="page" value="#rc.page#" />
				<input type="hidden" name="sortorder" value="#rc.sortorder#" />

				&nbsp; &nbsp;  
				<div class="form-group">
					<input type="text" class="form-control" placeholder="Keyword" name="keyword" value="#rc.keyword#" data-toggle="tooltip" title="keyword">
				</div>

				&nbsp; &nbsp;  
				<div class="form-group">
					<!---
					<input type="text" class="form-control" placeholder="0" name="level_range" style="width:45px;" value="#listGetAt(rc.level_range,1)#" data-toggle="tooltip" title="Level Range From">
					<input type="text" class="form-control" placeholder="80" name="level_range" style="width:45px;" value="#listGetAt(rc.level_range,2)#" data-toggle="tooltip" title="Level Range To">
					--->
					<input type="date" class="form-control"  name="createdafter" value="#rc.createdafter#" style="width:160px" data-toggle="tooltip" title="Created After Date" />

					<input type="date" class="form-control"  name="createdBefore" value="#rc.createdBefore#" style="width:160px" data-toggle="tooltip" title="Created Before Date" />
				</div>
				
				&nbsp; &nbsp;
				<div class="form-group" data-toggle="tooltip" title="Per Page">
					<select name="per_page" id="per_page" data-placeholder="Per page" class="chosen-select form-control" style="width:80px;">
						<cfloop from="50" to="200" index="i" step="50">
							<option value="#i#" <cfif rc.per_page eq i>selected</cfif>>#i#</option>
						</cfloop>
					</select>
				</div>
				
				<!---
				&nbsp; &nbsp;
				<div class="form-group" data-toggle="tooltip" title="Sorting Options">
					<select name="sortorder_" id="sortorder_" data-placeholder="Sort" class="chosen-select form-control" multiple style="width:260px;">
						<option value="name asc" <cfif arrayContains(rc.sortOrderArr,'name asc')>selected</cfif>>Name  &uarr;</option>
						<option value="name desc" <cfif arrayContains(rc.sortOrderArr,'name desc')>selected</cfif>>Name &darr;</option>
						
						<option value="level asc" <cfif arrayContains(rc.sortOrderArr,'level asc')>selected</cfif>>Level  &uarr;</option>
						<option value="level desc" <cfif arrayContains(rc.sortOrderArr,'level desc')>selected</cfif>>Level &darr;</option>
						
						<option value="rarity_id asc" <cfif arrayContains(rc.sortOrderArr,'rarity_id asc')>selected</cfif>>Rarity  &uarr;</option>
						<option value="rarity_id desc" <cfif arrayContains(rc.sortOrderArr,'rarity_id desc')>selected</cfif>>Rarity &darr;</option>
						
						<option value="itemtype_name asc" <cfif arrayContains(rc.sortOrderArr,'itemtype_name asc')>selected</cfif>>Type  &uarr;</option>
						<option value="itemtype_name desc" <cfif arrayContains(rc.sortOrderArr,'itemtype_name desc')>selected</cfif>>Type &darr;</option>
						
						<option value="supply asc" <cfif arrayContains(rc.sortOrderArr,'supply asc')>selected</cfif>>Supply  &uarr;</option>
						<option value="supply desc" <cfif arrayContains(rc.sortOrderArr,'supply desc')>selected</cfif>>Supply &darr;</option>
						
						<option value="demand asc" <cfif arrayContains(rc.sortOrderArr,'demand asc')>selected</cfif>>Demand  &uarr;</option>
						<option value="demand desc" <cfif arrayContains(rc.sortOrderArr,'demand desc')>selected</cfif>>Demand &darr;</option>
						
						<option value="last_min_sale asc" <cfif arrayContains(rc.sortOrderArr,'last_min_sale asc')>selected</cfif>>Max Sale Price  &uarr;</option>
						<option value="last_min_sale desc" <cfif arrayContains(rc.sortOrderArr,'last_min_sale desc')>selected</cfif>>Max Sale Price &darr;</option>
						
						<option value="last_max_offer asc" <cfif arrayContains(rc.sortOrderArr,'last_max_offer asc')>selected</cfif>>Max Buy Price  &uarr;</option>
						<option value="last_max_offer desc" <cfif arrayContains(rc.sortOrderArr,'last_max_offer desc')>selected</cfif>>Max Buy Price &darr;</option>
						
						<option value="upgradecomponent_price_difference asc" <cfif arrayContains(rc.sortOrderArr,'upgradecomponent_price_difference asc')>selected</cfif>>Component Difference &uarr;</option>
						<option value="upgradecomponent_price_difference desc" <cfif arrayContains(rc.sortOrderArr,'upgradecomponent_price_difference desc')>selected</cfif>>Component Difference &darr;</option>
						
						
					</select>
				</div>
				--->
				<div class="form-group">
					<button type="submit" class="btn btn-default form-control">Submit</button>
				</div>
			</div>
		</div>
		

	</form>
</div>

<br />

<div class="panel panel-default">
	<table class="table vmiddle" id="logtable">
		<thead>
			<tr>
				<th class="sort text-primary" data-param="sortorder" data-value="id #(rc.sortorder eq 'id asc' ? 'desc' : 'asc')#">##</th>
				<th class="sort text-primary" data-param="sortorder" data-value="a.id #(rc.sortorder eq 'a.id asc' ? 'desc' : 'asc')#">App##</th>
				<th class="text-primary content-head">
					<span class="sort" data-param="sortorder" data-value="c.user_ip #(rc.sortorder eq 'c.user_ip asc' ? 'desc' : 'asc')#">IP</span>
					<span class="sort" data-param="sortorder" data-value="c.author #(rc.sortorder eq 'c.author asc' ? 'desc' : 'asc')#">Author</span>
					<span class="sort" data-param="sortorder" data-value="c.content #(rc.sortorder eq 'c.content asc' ? 'desc' : 'asc')#">Content</span>
				</th>
				<th class="sort text-primary" data-param="sortorder" data-value="lookupcount #(rc.sortorder eq 'lookupcount asc' ? 'desc' : 'asc')#">Lookups</th>
				<th class="sort text-primary" data-param="sortorder" data-value="spamconfidence #(rc.sortorder eq 'spamconfidence asc' ? 'desc' : 'asc')#">Confidence</th>
				<th class="sort text-primary" data-param="sortorder" data-value="created #(rc.sortorder eq 'created asc' ? 'desc' : 'asc')#">Date</th>
				<th id="togglehams" style="text-align:center; cursor:pointer;">Ham</th>
				<th id="togglespams" style="text-align:center; cursor:pointer;">Spam</th>
			</tr>
		</thead>
		<tfoot>
			<tr>
				<td colspan="9" style="text-align:right; padding-right:25px;">
					<button id="submittypes" class="btn btn-default">Save</button>
				</td>
			</tr>
		</tfoot>
		<tbody>
			<cfloop array="#rc.Logs.Entries#" index="Log">
				#renderView('log/log_tr')#
			</cfloop>
		</tbody>
	</table>

	<div align="center">
		<cfset plink = event.buildLink(linkTo='log.index/page/@page@') />
		#rc.Paging.renderit(rc.Logs.count, plink )#
	</div>

</div>


</div>
</cfoutput>
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
				<th></th>
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
<cfset addAsset("/includes/js/settings.js") />

<cfoutput>
	<table class="table vmiddle" id="settings-admin" data-endpoint="/manage/settings">
		<thead>
			<tr>
				<th class="sort text-primary" data-param="sortorder" data-value="key #(Event.getValue('sortorder','') eq 'name asc' ? 'desc' : 'asc')#">Key</th>
				<th class="sort text-primary" data-param="sortorder" data-value="value #(Event.getValue('sortorder','') eq 'name asc' ? 'desc' : 'asc')#">Value</th>
				<th class="sort text-primary" data-param="sortorder" data-value="value #(Event.getValue('sortorder','') eq 'created asc' ? 'desc' : 'asc')#">Created</th>
				<th class="sort text-primary" data-param="sortorder" data-value="value #(Event.getValue('sortorder','') eq 'updated asc' ? 'desc' : 'asc')#">Updated</th>
				<th class="text-primary">&nbsp;</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="rc.settings" group="category">
				<tr>
					<td colspan="5"><h4>#Category#</h4></td>
				</tr>
				<cfloop>
					<tr data-toggle="tooltip" title="#description#">
						<td>#Key#</td>
						<td class="col-lg-4">
							<input type="text" class="form-control" name="value" data-key="#Key#" value="#Value#" />
						</td>
						<td>#DateFormat(Created,'medium')# #TimeFormat(Created,'medium')#</td>
						<td>#DateFormat(Updated,'medium')# #TimeFormat(Updated,'medium')#</td>
						<td>
							<a href="##" data-key="#Key#" class="fa fa-times-circle fa-2x delete" title="Delete"></a>
						</td>
					</tr>
				</cfloop>
			</cfloop>
			<tr>
				<td colspan="3" align="center">
					<button id="save" class="btn btn-default">Save</button>
				</td>
			</tr>
		</tbody>
	</table>
	
</cfoutput>


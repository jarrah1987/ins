
<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="../util/head.jsp"%>
<script type="text/javascript" src="<%=path%>/js/common.js"></script>
<title></title>
</head>
<body style="padding: 3px; border: 0px">
	<input type="hidden" id="ifGLY" />
	
	<div id="tb" style="padding: 5px; height: auto">
		<div class="condition-container">
			<form id="form" action="" method="post">
				<input type="hidden" name="selected" value="" />
				<table class="condition">
					<tr>
						<td width="20%" nowrap="nowrap">开始时间：</td>
						<td width="30%">
							<div class="condition-text-container">
							<input class="condition-text condition"
								type="text" name="min_time" id="min_time" 
								onClick="WdatePicker();" />
							</div>
						</td>
						<td width="20%">截止日期：</td>
						<td width="30%">
							<div class="condition-text-container">
								<input name="max_time" id="max_time" onClick="WdatePicker({minDate:'#F{$dp.$D(\'min_time\')}'})" type="text" class="condition-text" />
							</div></td><!--						
						<td width="10%">地市名称：</td>
							<td width="20%">
							<div>
								<select name="area_id" id="area_id" class="condition-select">
									<option value=''>--请选择--</option>
									<c:forEach items="${area}" var="areaInfo">
										<option value='${areaInfo.AREA_ID}'>${areaInfo.NAME}</option>
									</c:forEach>
								</select>
							</div>
						   </td>	
					--></tr>
				</table>
			</form>
		</div>
		<div class="btn-operation-container">
			
			<div style="float: left;" class="btn-operation"
				onClick="inspectArDownload()">导出</div>
			<div style="float: right;" class="btn-operation"
				onClick="searchData()">查询</div>
		</div>
	</div>
    <table id="dg" title="【】" style="width:100%" class="common-table">
		<thead id="tsh">
		   
		  </thead>
		<tbody id="tsb">
		</tbody>
	</table>
	
	
	<iframe src="" style="display: none;" id="hiddenIframe"></iframe>
	<script type="text/javascript"><!--
		$(document).ready(function() {
		
			//searchData();
		});
		
		
		function searchData() {
			if($("#min_time").val()==''){
				alert("开始日期不能为空！");
				return false;
			}
			
			if($("#max_time").val()==''){
				alert("截止日期不能为空！");
				return false;
			}
			
			var obj=makeParamJson('form');
			
			//return;
			$('#dg').datagrid({
				//此选项打开，表格会自动适配宽度和高度。
				autoSize : true,
				fitColumns:true,
				toolbar : '#tb',
				url : webPath + "xxdReportController/getProvinceRoutingFacility.do",
				queryParams : obj,
				method : 'post',
				rownumbers : true,
				singleSelect : false,
				columns : [ [ {
					field : 'EQUIP_TYPE_NAME',
					title : '设施类型',
					width : 80,
					align : 'center'
				}, {
					field : 'TNUMEBER',
					title : '数量（N）',
					width : 80,
					align : 'center'
				}, {
					field : 'CHECK_NUM',
					title : '已检查数量（n）',
					width : 80,
					align : 'center'
				}, {
					field : 'CHECK_RATE',
					title : '检查完成率（n/N*100%）',
					width : 80,
					align : 'center'
				},{
					field : 'TROUBLE_NUM',
					title : '问题设施数量（t）',
					width : 80,
					align : 'center'
				},{
					field : 'COMPLETE_RATE',
					title : '设施完好率（1-t/n）*100%',
					width : 80,
					align : 'center'
				}
				]],
				nowrap : false,
				striped : true,
				onLoadSuccess : function(data) {
       			// $(this).datagrid("fixRownumber");
       			 
				
				}
				
				
			});
			
		}
		

//		function clearCondition(form_id) {		
//			$("#"+form_id+"").form('reset'	, 'none');
			
//		}
		

		function getParamsForDownloadLocal(idOrDom) {
			if (!idOrDom) {
				return;
			}
			var o;
			if (typeof idOrDom == "string") {
				o = $("#" + idOrDom);
			} else {
				o = $(idOrDom);
			}
			var res = "?randomPara=1";
			o.find("input,select").each(function() {
				var o = $(this);
				var tag = this.tagName.toLowerCase();
				var name = o.attr("name");
				if (name) {
					if (tag == "select") {
						if(o.find("option:selected").val()=='all' || o.find("option:selected").val()=='' ){
							res=res+"&"+name+"=";
						}else{
							res=res+"&"+name+"="+o.find("option:selected").val();
						}
						
					} else if (tag == "input") {
						res=res+"&"+name+"="+ o.val();
					}
				}
			});
			return res;
		}

		
		function inspectArDownload(){
		if($("#min_time").val()==''){
				alert("开始日期不能为空！");
				return false;
			}
			if($("#max_time").val()==''){
				alert("结束日期不能为空！");
				return false;
			}
		
			
			window.open(webPath + "xxdReportController/getProvinceRoutingFacilityDown.do"+getParamsForDownloadLocal('form'));
		}
	</script>

</body>
</html>

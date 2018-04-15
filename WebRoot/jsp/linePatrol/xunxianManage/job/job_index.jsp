
<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="../../../util/head.jsp"%>
<title>巡线计划管理</title>
</head>
<body style="padding: 3px; border: 0px">
	<input type="hidden" id="ifGLY" />
	<table id="dg" title="【巡线计划管理】" style="width: 100%; height: 480px">
	</table>
	<div id="tb" style="padding: 5px; height: auto">
		<div class="condition-container">
			<form id="form" action="" method="post">
				<input type="hidden" name="selected" value="" />
				<table class="condition">
					<tr>
						<td width="10%">计划名称：</td>
						<td width="20%">
							<div class="condition-text-container">
								<input name="param_job_name" id="param_job_name" type="text" class="condition-text" />
							</div>
						</td>
						<td width="10%">开始时间：</td>
						<td width="20%">
							<div class="condition-text-container">
								<input name="param_start_date" id="param_start_date" type="text" class="condition-text" onClick="WdatePicker();" />
							</div>
						</td>
						<td width="10%">结束时间：</td>
						<td width="20%">
							<div class="condition-text-container">
								<input name="param_end_date" id="param_end_date" type="text" class="condition-text" onClick="WdatePicker();" />
							</div>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div class="btn-operation-container">
			<div class="btn-operation" onClick="addJob()">增加</div>
			<div class="btn-operation" onClick="editJob()">编辑</div>
			<div class="btn-operation" onClick="stopJob()">暂停</div>

			<div style="float:right;" class="btn-operation"
				onClick="clearCondition('form')">重置</div>
			<div style="float: right;" class="btn-operation"
				onClick="searchData()">查询</div>
		</div>
	</div>
	<div id="win_job"></div>
	
	<iframe src="" style="display: none;" id="hiddenIframe"></iframe>
	<script type="text/javascript">
		$(document).ready(function() {
			searchData();
		});
		
		
		function searchData() {
			
			var obj=makeParamJson('form');
			
			//return;
			$('#dg').datagrid({
				//此选项打开，表格会自动适配宽度和高度。
				autoSize : true,
				toolbar : '#tb',
				url : webPath + "lineJob/query.do",
				queryParams : obj,
				method : 'post',
				pagination : true,
				pageNumber : 1,
				pageSize : 10,
				pageList : [ 20, 50 ],
				//loadMsg:'数据加载中.....',
				rownumbers : true,
			
				singleSelect : false,
				//
				columns : [ [ {
					field : 'JOB_ID',
					title : '计划ID',
					checkbox : true
				}, {
					field : 'JOB_NAME',
					title : '计划名称',
					width : "20%",
					align : 'center'
				}, {
					field : 'START_DATE',
					title : '开始时间',
					width : "12%",
					align : 'center'
				}, {
					field : 'END_DATE',
					title : '结束时间',
					width : "12%",
					align : 'center'
				}, {
					field : 'CIRCLE_ID',
					title : '周期',
					width : "12%",
					align : 'center'
				},{
					field : 'FIBER_GRADE',
					title : '干线等级',
					width : "12%",
					align : 'center'
				},{
					field : 'AREA_NAME',
					title : '城市',
					width : "12%",
					align : 'center'
				},{
					field : 'CREATOR',
					title : '创建者',
					width : "10%",
					align : 'center'
				},{
					field : 'CREATE_DATE',
					title : '创建时间',
					width : "10%",
					align : 'center'
				}] ],
				//width : 'auto',
				nowrap : false,
				striped : true,
				//onClickRow:onClickRow,
				//onCheck:onCheck,
				//onSelect:onSelect,
				//onSelectAll:onSelectAll,
				onLoadSuccess : function(data) {
       			// $(this).datagrid("fixRownumber");
       			 
				
				}
				
				
			});
		}
		/**选择行触发**/
		function onClickRow(index, row) {
			alert("onClickRow");
		}
		/**点击checkbox触发**/
		function onCheck(index, row) {
			alert("onCheck");
		}

		function onSelect(index, row) {
			alert("onSelect");
		}

		function onSelectAll(rows) {
			alert(rows);
			alert("onSelectAll");
		}

		function clearCondition(form_id) {
			
			$("#"+form_id+"").form('reset', 'none');
			
		}

		function addJob() {
			 $('#win_job').window({
					title : "【新增巡线计划】",
					href : webPath + "lineJob/toAdd.do",
					width : 400,
					height : 300,
					zIndex : 2,
					region : "center",
					collapsible : false,
					cache : false,
					modal : true
				});
		}
		
		function saveForm() {
			if ($("#formAdd").form('validate')) {
				$.messager.confirm('系统提示', '您确定要新增巡线计划吗?', function(r) {
					if (r) {
						var data=makeParamJson('formAdd');
						$.ajax({
							type : 'POST',
							url : webPath + "lineJob/add.do",
							data : data,
							dataType : 'json',
							success : function(json) {
								if (json.status) {
									$.messager.show({
										title : '提  示',
										msg : '新增计划成功！',
										showType : 'show',
										timeout:'1000'//ms
									   
									});
								}
								else{
									$.messager.alert("提示","新增计划失败！","info");
									return;
								}
								$('#win_job').window('close');
								searchData();

							}
						});
					}
				});
			}
		}
		
		
		function editJob() {
			var selected = $('#dg').datagrid('getChecked');
			var count = selected.length;
			if (count == 0) {
				$.messager.show({
					title : '提  示',
					msg : '请选取一条数据!',
					showType : 'show',
					 timeout:'1000'//ms
				});
				return;
			} else if (count > 1) {
				$.messager.show({
					title : '提  示',
					msg : '仅能选取一条数据!',
					showType : 'show',
					timeout:'1000'//ms
				});
				return;
			} else {
				var job_id = selected[0].JOB_ID;
				
				$('#win_job').window({
					title : "【编辑计划】",
					href : webPath + "lineJob/toUpdate.do?job_id=" + job_id,
					width : 400,
					height : 500,
					zIndex : 2,
					region : "center",
					collapsible : false,
					cache : false,
					modal : true
				}); 
			}

		}

		function stopJob() {
			var selected = $('#dg').datagrid('getChecked');
			var count = selected.length;
			if (count == 0) {
				$.messager.show({
					title : '提  示',
					msg : '请选取要暂停的计划!',
					showType : 'show',
					timeout:'1000'//ms
				});
				return;
			} else {
				$.messager.confirm('系统提示', '您确定要暂停计划吗?', function(r) {
					if (r) {
						var arr = new Array();
						for ( var i = 0; i < selected.length; i++) {
							var value = selected[i].JOB_ID;
							arr[arr.length] = value;
						}
						$("input[name='selected']").val(arr);
						$.messager.progress();
						$.ajax({async:false,
							  type:"post",
							  url : webPath + "lineJob/stop.do",
							  data:{ids:$("input[name='selected']").val()},
							  dataType:"json",
							  success:function(data){
								  $.messager.progress('close');
								  if(data.status){
										
										searchData();
										$.messager.show({
											title : '提  示',
											msg : '成功停止计划!',
											showType : 'show',
											timeout:'1000'//ms
										   
										});
									}else{
										alert("停止计划失败");
									}
							  }
						  });
						
						
					}
				});
			}
		}


		
		
		function updateForm() {
			var pass = $("#formEdit").form('validate');
			if (pass) {
				$.messager.confirm('系统提示', '您确定要更新计划吗?', function(r) {
					if (r) {
						var obj=makeParamJson('formEdit');
						$.ajax({
							type : 'POST',
							url : webPath + "lineJob/update.do",
							data : obj,
							dataType : 'json',
							success : function(json) {
								if (json.status) {
									$.messager.show({
										title : '提  示',
										msg : '更新计划成功!',
										showType : 'show',
										timeout:'1000'//ms
									});
								}
								$('#win_job').window('close');
								searchData();
							}
						})
					}
				});
			}
		}
	</script>

</body>
</html>
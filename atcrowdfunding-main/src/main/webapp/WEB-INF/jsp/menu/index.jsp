<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
	<%@include file="/WEB-INF/jsp/common/css.jsp" %>
	<style>
	.tree li {
        list-style-type: none;
		cursor:pointer;
	}
	table tbody tr:nth-child(odd){background:#F4F4F4;}
	table tbody td:nth-child(even){color:#C00;}
	</style>
  </head>

  <body>

	<jsp:include page="/WEB-INF/jsp/common/top.jsp"></jsp:include>

    <div class="container-fluid">
      <div class="row">
	<div class="col-sm-3 col-md-2 sidebar">
	<jsp:include page="/WEB-INF/jsp/common/menu.jsp"></jsp:include>
	</div>
	<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
			<div class="panel panel-default">
			  <div class="panel-heading">
				<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
			  </div>
			  <div class="panel-body">
					<ul id="treeDemo" class="ztree"></ul>
			  </div>
			</div>
        </div>
      </div>
    </div>




<!-- 添加模态框 -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">添加菜单</h4>
      </div>
      <div class="modal-body">
		  <div class="form-group">
			<label for="name">菜单名称</label>
			<input type="hidden" name="pid">
			<input type="text" class="form-control"  name="name" placeholder="请输入菜单名称">
		  </div>
		  <div class="form-group">
			<label for="icon">菜单图标</label>
			<input type="text" class="form-control"  name="icon" placeholder="请输入菜单图标">
		  </div>
		  <div class="form-group">
			<label for="url">菜单URL</label>
			<input type="text" class="form-control"  name="url" placeholder="请输入菜单URL">
		  </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
      </div>
    </div>
  </div>
</div>




<!-- 添加模态框 -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">修改菜单</h4>
      </div>
      <div class="modal-body">
		  <div class="form-group">
			<label for="name">菜单名称</label>
			<input type="hidden" name="id">
			<input type="text" class="form-control"  name="name" placeholder="请输入菜单名称">
		  </div>
		  <div class="form-group">
			<label for="icon">菜单图标</label>
			<input type="text" class="form-control"  name="icon" placeholder="请输入菜单图标">
		  </div>
		  <div class="form-group">
			<label for="url">菜单URL</label>
			<input type="text" class="form-control"  name="url" placeholder="请输入菜单URL">
		  </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="updateBtn" type="button" class="btn btn-primary">修改</button>
      </div>
    </div>
  </div>
</div>




<div class="modal fade" id="permissionModal" tabindex="-1" role="dialog" aria-labelledby="Modal">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">给菜单分配权限</h4>
      </div>
      <div class="modal-body">
 			<ul id="assignPermissionTree" class="ztree"></ul>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="assignPermission" type="button" class="btn btn-primary">分配</button>
      </div>
    </div>
  </div>
</div>



	<%@include file="/WEB-INF/jsp/common/js.jsp" %>

	
        <script type="text/javascript">
            $(function () { //页面ready函数。
			    $(".list-group-item").click(function(){
				    if ( $(this).find("ul") ) {
						$(this).toggleClass("tree-closed");
						if ( $(this).hasClass("tree-closed") ) {
							$("ul", this).hide("fast");
						} else {
							$("ul", this).show("fast");
						}
					}
				});	
            
            	//页面加载完成时，就初始化树
            	loadTree();
            });  
            
            function loadTree(){
            	var setting = {
            			data: {
            				simpleData: {
            					enable: true,
            					pIdKey:'pid'
            				}
            			},
            			view: {
            				//treeNode表示一个节点，而一个节点其实就是一个后台TMenu对象。
            				addDiyDom: function(treeId, treeNode){ // treeId就是容器id;  treeNode就是每一个具体的节点
            					$("#"+treeNode.tId+"_ico").removeClass();//.addClass();
            					$("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>");
            				},
    						addHoverDom: function(treeId, treeNode){  //鼠标移动到节点上触发事件，增加按钮组 
    							var aObj = $("#" + treeNode.tId + "_a"); // tId = permissionTree_1, ==> $("#permissionTree_1_a")
    							//aObj.attr("href", "javascript:;"); //禁用href,不起作用。这样设置是无效的。
    							// <a href="#" onclick="return false;">xxx</a>
    							
    							//禁用href
    							aObj.attr("href","#");
    							aObj.attr("onclick","return false;");
    							
    							if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;
    							
    							var s = '<span id="btnGroup'+treeNode.tId+'">';
    							if ( treeNode.level == 0 ) { //根节点
    								s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="add('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
    							} else if ( treeNode.level == 1 ) { //分支节点
    								s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="update('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
    								if (treeNode.children.length == 0) {  //没有子节点的节点，可以删除的。
    									s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="remove('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
    								}
    								s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="add('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
    							} else if ( treeNode.level == 2 ) { //叶子节点
    								s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="update('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
    								s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="remove('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
    								s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="assignBtn('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-anchor rbg "></i></a>';
    							}
    			
    							s += '</span>';
    							aObj.after(s);
    						},
    						removeHoverDom: function(treeId, treeNode){ //鼠标移出节点触发的事件，隐藏按钮组
    							$("#btnGroup"+treeNode.tId).remove();
    						}
            			}
            	};
            	$.get("${PATH}/menu/loadTree",{},function(zNodes){
            		/* 
            		zNodes = [	{"id":0,"name":"系统权限菜单","icon":"glyphicon glyphicon-dashboard"},
            			{"id":1,"pid":0,"name":"控制面板","icon":"glyphicon glyphicon-dashboard","url":"main.html","childmenus":[]},
            			{"id":2,"pid":0,"name":"权限管理","icon":"glyphicon glyphicon glyphicon-tasks","url":null,"childmenus":[]},
            			{"id":3,"pid":2,"name":"用户维护","icon":"glyphicon glyphicon-user","url":"user/index","childmenus":[]}] */
            		
            		//临时追加根节点
            		zNodes.push({"id":0,"name":"系统权限菜单","icon":"glyphicon glyphicon-th-list"});
            			
            		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
            		
            		
            		var treeObj = $.fn.zTree.getZTreeObj("treeDemo"); //获取整颗树
            		treeObj.expandAll(true); //展开整颗树全部节点
            	});
            }
            
            //~~~~~添加~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            function add(id){  
            	$("#addModal input[name='pid']").val(id);
            	
            	$('#addModal').modal({ //弹出模态框
            		show:true,
            		backdrop:'static',
            		keyboard:false
            	})
            }
            
            
            $("#saveBtn").click(function(){
            	var pid = $("#addModal input[name='pid']").val();
            	var name = $("#addModal input[name='name']").val();
            	var icon = $("#addModal input[name='icon']").val();
            	var url = $("#addModal input[name='url']").val();
            	$.ajax({
            		type:'post',
            		url:"${PATH}/menu/save",
            		data:{
            			pid:pid,
            			name:name,
            			icon:icon,
            			url:url
            		},
            		success:function(result){ //  result='ok'   result='fail'
            			if(result=='ok'){            				
            				layer.msg("添加成功",{time:1000,icon:6},function(){
            					$('#addModal').modal('hide');
            					$("#addModal input[name='pid']").val("");
                            	$("#addModal input[name='name']").val("");
                            	$("#addModal input[name='icon']").val("");
                            	$("#addModal input[name='url']").val("");
            					loadTree();
            				});
            			}else{
            				layer.msg("添加失败",{time:1000,icon:5});
            			}
            		}
            	});
            });
            
            
            
            //~~~~~修改~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            function update(id){
            	
            	//获取数据
            	$.get("${PATH}/menu/get",{id:id},function(result){
            		console.log(result);
            		
            		//回显数据
            		$("#updateModal input[name='id']").val(result.id);
            		$("#updateModal input[name='name']").val(result.name); // val()函数如果有参数表示赋值。
            		$("#updateModal input[name='icon']").val(result.icon);
            		$("#updateModal input[name='url']").val(result.url);
                	//弹模态框
                	$('#updateModal').modal({ //弹出模态框
	            		show:true,
	            		backdrop:'static',
	            		keyboard:false
	            	});
            	});            	
            	
            }
            
            
            $("#updateBtn").click(function(){
            	var id = $("#updateModal input[name='id']").val();
            	var name = $("#updateModal input[name='name']").val();
            	var icon = $("#updateModal input[name='icon']").val();
            	var url = $("#updateModal input[name='url']").val();
            	$.ajax({
            		type:'post',
            		url:"${PATH}/menu/update",
            		data:{
            			id:id,
            			name:name,
            			icon:icon,
            			url:url
            		},
            		success:function(result){ //  result='ok'   result='fail'
            			if(result=='ok'){
            				$('#updateModal').modal('hide');
            				layer.msg("修改成功",{time:1000,icon:6},function(){
            					loadTree();
            				});
            			}else{
            				layer.msg("修改失败",{time:1000,icon:5});
            			}
            		}
            	});
            });
            
            
            //~~~~~删除~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            
            function remove(id){
				layer.confirm('您确定要删除这条数据吗?', {btn:['确定','取消']}, function(index){
            		
            		$.post("${PATH}/menu/delete",{id:id},function(result){
                		if(result=='ok'){        				
            				layer.msg("删除成功",{time:1000,icon:6},function(){
            					loadTree();
            				});
            			}else{
            				layer.msg("删除失败",{time:1000,icon:5});
            			}
                	});
            		
            		layer.close(index);
            	}, function(index){
            		layer.close(index);
            	});
            }


            
            //------给菜单分配许可----------------------------------------------------------------------------------          
			var tempMenuid = '';
			function assignBtn(menuid) {
				tempMenuid = menuid;
				//1.初始化权限树，带复选框
				initPermissioinToMenuTree();
				//2.显示模态框，展示权限树
				$("#permissionModal").modal({
					show : true,
					backdrop : "static"
				});
				//3.回显权限树（之前分配过的权限应该被勾选）
				//showMenuPermissions(menuid);
			}
			function initPermissioinToMenuTree() {
				var setting = {
					data : {
						simpleData : {
							enable : true,
							pIdKey : "pid"
						},
						key : {
							url : "xUrl",
							name : "title"
						}
					},
					check : {
						enable : true
					},
					view : {
						addDiyDom : addDiyDom
					}
				};
				//1.加载数据
				$.get("${PATH}/permission/listAllPermissionTree",function(data) {
						//data.push({"id":0,"title":"系统权限","icon":"glyphicon glyphicon-asterisk"});
						var tree = $.fn.zTree.init($("#assignPermissionTree"),setting,data);
						var treeObj = $.fn.zTree.getZTreeObj("assignPermissionTree");
						treeObj.expandAll(true);
						
						showMenuPermissions(tempMenuid);
				});
			}
			function addDiyDom(treeId, treeNode) {
				$("#" + treeNode.tId + "_ico").removeClass();
				$("#" + treeNode.tId + "_span").before('<span class="'+treeNode.icon+'"></span>');
			}
			
			
			
			//分配权限功能
			$("#assignPermission").click(function(){
				//1、获取到已经选中的所有权限的id
				var treeObj = $.fn.zTree.getZTreeObj("assignPermissionTree");
				var ids = new Array();
				$.each(treeObj.getCheckedNodes(true),function(){
					ids.push(this.id);
				});
				var idsStr = ids.join();
					 
				//2、组装给后台提交的数据
				var data = {mid:tempMenuid,perIds:idsStr};
				console.log(data);
				//3、发请求，完成权限分配功能
				$.post("${PATH}/menu/assignPermissionToMenu",data,function(){
					layer.msg("权限分配完成...")
					$("#permissionModal").modal('hide');
				})
			});

			
			//回显权限树
			function showMenuPermissions(menuid){
				$.get("${PATH}/menu/menu_permission?menuid="+menuid,function(data){
					//1、遍历每一个权限，在ztree中选中对应的节点
					$.each(data,function(){
						console.log(this);
						var treeObj = $.fn.zTree.getZTreeObj("assignPermissionTree");
						var node = treeObj.getNodeByParam("id", this.id, null); //根据指定的节点id搜索节点，null表示搜索整个树
						treeObj.checkNode(node,true,false);//需要回显的节点，是否勾选复选框，父子节点勾选是否联动（例如：勾选父节点，要不要把它的所有子节点都勾上，取消父节点勾选，要不要把它的所有子节点也都取消勾选）
					});
				});
			} 
        </script>
  </body>
</html>
    
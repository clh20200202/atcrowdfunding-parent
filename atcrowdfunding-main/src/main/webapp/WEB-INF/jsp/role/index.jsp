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
<form class="form-inline" role="form" style="float:left;">
  <div class="form-group has-feedback">
    <div class="input-group">
      <div class="input-group-addon">查询条件</div>
      <input id="condition" class="form-control has-success" type="text" placeholder="请输入查询条件">
    </div>
  </div>
  <button id="queryBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
</form>
<button type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
<button id="addBtn" type="button" class="btn btn-primary" style="float:right;" ><i class="glyphicon glyphicon-plus"></i> 新增</button>
<br>
 <hr style="clear:both;">
          <div class="table-responsive">
            <table class="table  table-bordered">
              <thead>
                <tr >
                  <th width="30">#</th>
				  <th width="30"><input type="checkbox"></th>
                  <th>名称</th>
                  <th width="100">操作</th>
                </tr>
              </thead>
              <tbody>
              
              </tbody>
			  <tfoot>
			     <tr >
				     <td colspan="6" align="center">
						<ul class="pagination"></ul>
					 </td>
				 </tr>

			  </tfoot>
            </table>
          </div>
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
        <h4 class="modal-title" id="myModalLabel">添加角色</h4>
      </div>
      <div class="modal-body">
		  <div class="form-group">
			<label for="exampleInputPassword1">角色名称</label>
			<input type="text" class="form-control"  name="name" placeholder="请输入用户名称">
		  </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
      </div>
    </div>
  </div>
</div>




<!-- 修改模态框 -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">修改角色</h4>
      </div>
      <div class="modal-body">
		  <div class="form-group">
			<label for="exampleInputPassword1">角色名称</label>
			<input type="hidden" name="id">
			<input type="text" class="form-control" name="name" placeholder="请输入用户名称">
		  </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="updateBtn" type="button" class="btn btn-primary">修改</button>
      </div>
    </div>
  </div>
</div>



<!-- 给角色分配许可模态框 -->
<div class="modal fade" id="assignModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">给角色分配许可</h4>
      </div>
      <div class="modal-body">
		  <ul id="treeDemo" class="ztree"></ul>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="assignBtn" type="button" class="btn btn-primary">分配</button>
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
			    
			    loadData(1); //页面被加载，立即初始化分页数据（局部刷新数据）
            });            
            
            var json = {
        			pageNum:1,
        			pageSize:2,
        			condition:''
        	};
            
            function loadData(pageNum){
            	
            	json.pageNum = pageNum ;
            	
            	var index = -1;
            	$.ajax({
            		type:"post",
            		url:"${PATH}/role/loadData",
            		data:json,
            		beforeSend:function(){
            			index = layer.load(0, {time:1000*10}); //0代表加载的风格，支持0-2
            			return true ;
            		},
            		success:function(result){  // PageInfo<TRole> =>>>   JSON
            			/* result = {"pageNum":1,"pageSize":2,
            				"size":2,"startRow":1,
            				"endRow":2,"total":13,
            				"pages":7,
            				"list":[{"id":1,"name":"PM - 项目经理"},{"id":2,"name":"SE - 软件工程师"}],
            				"prePage":0,"nextPage":2,"isFirstPage":true,"isLastPage":false,
            				"hasPreviousPage":false,"hasNextPage":true,"navigatePages":5,
            				"navigatepageNums":[1,2,3,4,5],"navigateFirstPage":1,
            				"navigateLastPage":5,"lastPage":5,"firstPage":1} */
            			layer.close(index);
            			console.log(result);
            			
            			//局部刷新列表数据
            			showData(result);
            			
            			//局部刷新分页条
            			pageNav(result);
            			
            		}
            	});
            }
            
            
            function showData(result){
            	//局部刷新列表数据
    			var list = result.list ; //:[{"id":1,"name":"PM - 项目经理"},{"id":2,"name":"SE - 软件工程师"}]
    			var content = '';
    			$.each(list,function(i,e){ //i是索引，从0开始 ；  e = {"id":1,"name":"PM - 项目经理"}
    				content+='<tr>';
        			content+='  <td>'+(i+1)+'</td>';
        			content+='  <td><input type="checkbox"></td>';
        			content+='  <td>'+e.name+'</td>';
        			content+='  <td>';
        			content+='	  <button type="button" roleId="'+e.id+'" class="assignBtnClass btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
        			content+='	  <button type="button" roleId="'+e.id+'" class="updateBtnClass btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
        			content+='	  <button type="button" roleId="'+e.id+'" class="deleteBtnClass btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
        			content+='  </td>';
        			content+='</tr>';
    			});
    			$("tbody").html(content);
            }
            
            
            function pageNav(result){
            	//局部刷新分页条
    			var pageNav = '';
    			if(result.isFirstPage){
    				pageNav+='<li class="disabled"><a>上一页</a></li>';
    			}else{
    				pageNav+='<li><a onclick="loadData('+(result.pageNum-1)+')">上一页</a></li>';
    			}    			
    			
    			$.each(result.navigatepageNums,function(i,e){
    				if(result.pageNum == e){
    					pageNav+='<li class="active"><a>'+e+'</a></li>';
    				}else{
    					pageNav+='<li><a onclick="loadData('+e+')">'+e+'</a></li>';
    				}            				
    			});    			
    			
    			if(result.isLastPage){
    				pageNav+='<li class="disabled"><a>下一页</a></li>';
    			}else{
    				pageNav+='<li><a onclick="loadData('+(result.pageNum+1)+')">下一页</a></li>';
    			}
    		
    			$(".pagination").html(pageNav);
            }
            
            
            //======条件查询=============================================================
            $("#queryBtn").click(function(){
            	var condition = $("#condition").val();
            	json.condition = condition;
            	loadData(1);
            });
            
            
            
            
            //====添加================================================================
            $("#addBtn").click(function(){
            	$('#addModal').modal({ //弹出模态框
            		show:true,
            		backdrop:'static',
            		keyboard:false
            	})
            });
            
            
            $("#saveBtn").click(function(){
            	var name = $("#addModal input[name='name']").val();
            	$.ajax({
            		type:'post',
            		url:"${PATH}/role/save",
            		data:{
            			name:name
            		},
            		success:function(result){ //  result='ok'   result='fail'
            			if(result=='ok'){
            				$('#addModal').modal('hide');
            				layer.msg("保存成功",{time:1000,icon:6});
            				loadData();
            			}else if(result=="403"){
            				layer.msg("您无权访问",{time:1000,icon:5});
            			}else{
            				layer.msg("保存失败",{time:1000,icon:5});
            			}
            		}
            	});
            });
            
            
            
            
            //=======修改=========================================================================
            /* 页面后来元素，不能直接绑定click事件
            $(".updateBtnClass").click(function(){
            	alert("ok");
            });
             */
            
            //可以给后来元素增加事件
            $("tbody").on("click",".updateBtnClass",function(){
            	//var roleId = this.roleId ;  // this是dom对象，不能直接获取自定义属性。
            	
            	var roleId = $(this).attr("roleId") ; // dom对象转换为jquery对象,用 $()进行转换即可。
            
            	//获取数据
            	$.get("${PATH}/role/get",{roleId:roleId},function(result){ //  result = {"id":1,"name":"PM - 项目经理"};
            		console.log(result);
            		
            		//回显数据
            		$("#updateModal input[name='name']").val(result.name); // val()函数如果有参数表示赋值。
            		$("#updateModal input[name='id']").val(result.id);
                	//弹模态框
                	$('#updateModal').modal({ //弹出模态框
	            		show:true,
	            		backdrop:'static',
	            		keyboard:false
	            	})
            	}); 
            });
            
            
            $("#updateBtn").click(function(){
            	var name = $("#updateModal input[name='name']").val(); // val()函数如果没有参数表示取值。
        		var id = $("#updateModal input[name='id']").val();
            	
            	$.post("${PATH}/role/update",{id:id,name:name},function(result){
            		if(result=='ok'){
        				$('#updateModal').modal('hide');
        				layer.msg("修改成功",{time:1000,icon:6},function(){
        					loadData(json.pageNum);
        				});
        			}else{
        				layer.msg("修改失败",{time:1000,icon:5});
        			}
            	});
            });
            
            //======删除=========================================================================
            
            $("tbody").on("click",".deleteBtnClass",function(){
            	var roleId = $(this).attr("roleId") ; 
            	
            	//询问框

            	layer.confirm('您确定要删除这条数据吗?', {btn:['确定','取消']}, function(index){
            		
            		$.post("${PATH}/role/delete",{id:roleId},function(result){
                		if(result=='ok'){        				
            				layer.msg("删除成功",{time:1000,icon:6},function(){
            					loadData(json.pageNum);
            				});
            			}else{
            				layer.msg("删除失败",{time:1000,icon:5});
            			}
                	});
            		
            		layer.close(index);
            	}, function(index){
            		layer.close(index);
            	});
            });
            
            
            //~~~~~~~给角色分配许可（权限）~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            
            var roleId = null;
            $("tbody").on("click",".assignBtnClass",function(){
            	
            	roleId = $(this).attr("roleId");
            	
            	initTree();
            	
            	$("#assignModal").modal({
            		show:true,
            		backdrop:'static',
            		keyboard:false
            	});
            });
            
            
        	function initTree(){
        		
        		var setting = {
        				data: {
        					simpleData: {
        						enable: true,
        						pIdKey: "pid"
        					},
        					key: {
        						url: "xUrl", //指定不存在的地址，这样点击节点时不进行跳转
        						name:"title"
        					}
        				},
        				view: {
        					addDiyDom: function(treeId,treeNode){
        						$("#"+treeNode.tId+"_ico").removeClass();
        						$("#"+treeNode.tId+"_span").before('<span class="'+treeNode.icon+'"></span>');
        					}
        				},
        				check: {
        					enable: true
        				}
        				
        		};
        		
        		// 两个异步请求并行，会出现回显不上的情况。需要将两个并行请求修改为两个串行请求。
        		
        		//1.加载数据
        		$.get("${PATH}/permission/listAllPermissionTree",function(data){
        			var tree = $.fn.zTree.init($("#treeDemo"), setting, data);
        			var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        			treeObj.expandAll(true);
        			
        			
        			//2.回显数据,把已经分配的许可id查询出来
            		$.get("${PATH}/role/listPermissionIdByRoleId",{roleId:roleId},function(data){
            			console.log(data);
            			$.each(data,function(i,e){
            				var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            				var node = treeObj.getNodeByParam("id", e, null); //表示从整颗树上查找id=xxx的节点
            				treeObj.checkNode(node, true, false); //节点   打钩   是否联动
            			});
            		});
        		}); 
        		
        		 

        	}
        	
        	
        	//给角色分配许可
        	$("#assignBtn").click(function(){
        		var rid = roleId ;
        		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        		var nodes = treeObj.getCheckedNodes(true); //获取树上被勾选的节点集合
        		
        		
        		//  roleId=2&permissionId=1&permissionId=2&permissionId=3
        		var str = 'roleId='+rid;
        		
        		$.each(nodes,function(i,e){
        			var permissionId = e.id; //  e 就表示节点数据，节点就是就是由TPermission对象生成JSON串  {id:1,name:'user:add',title:'添加'}
        			str+="&";
        			str+="ids="+permissionId
        		});
        		
        		
        		$.ajax({
            		type:"post",
            		url:"${PATH}/role/doAssignPermissionToRole",
            		data:str,
            		success:function(result){
            			if("ok"==result){
            				$("#assignModal").modal('hide');
            				layer.msg("分配成功");
            			}else{
            				layer.msg("分配失败");
            			}
            		}
            	});
        		
        	});

            
        </script>
  </body>
</html>
    
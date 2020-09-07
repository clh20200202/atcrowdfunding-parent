<%@page pageEncoding="UTF-8"%>
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
				<ol class="breadcrumb">
				  <li><a href="#">首页</a></li>
				  <li><a href="#">数据列表</a></li>
				  <li class="active">修改</li>
				</ol>
			<div class="panel panel-default">
              <div class="panel-heading">表单数据<div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i class="glyphicon glyphicon-question-sign"></i></div></div>
			  <div class="panel-body">
				<form id="userForm" action="${PATH}/admin/update?id=${param.id}&pageno=${param.pageno}" method="post" role="form">
				  <div class="form-group">
					<label for="exampleInputPassword1">登陆账号</label>
					<input type="text" class="form-control" id="loginacct" name="loginacct" value="${admin.loginacct}">
				  </div>
				  <div class="form-group">
					<label for="exampleInputPassword1">用户名称</label>
					<input type="text" class="form-control" id="username" name="username" value="${admin.username}">
				  </div>
				  <div class="form-group">
					<label for="exampleInputEmail1">邮箱地址</label>
					<input type="email" class="form-control" id="email" name="email" value="${admin.email}">
					<p class="help-block label label-warning">请输入合法的邮箱地址, 格式为： xxxx@xxxx.com</p>
				  </div>
				  <button type="button" class="btn btn-success" onclick="doUpdateAdmin()"><i class="glyphicon glyphicon-edit"></i> 修改</button>
				  <button type="button" class="btn btn-danger" onclick="doReset()"><i class="glyphicon glyphicon-refresh"></i> 重置</button>
				</form>
			  </div>
			</div>
        </div>
      </div>
    </div>

  <%@include file="/WEB-INF/jsp/common/js.jsp" %>
        <script type="text/javascript">
            $(function () {
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
            });
            
            function doUpdateAdmin() {
            	// 表单校验
            	var loginacct = $("#loginacct").val();
            	if ( $.trim(loginacct) == "" ) {
            	    //alert("登陆账号不能为空，请输入");
					layer.msg("登陆账号不能为空，请输入", {time:3000, icon:5, shift:6}, function(index){
						layer.close(index);
					});
            	    // 设定页面焦点
            	    $("#loginacct").focus();
            	    return;
            	}
            	
            	var username = $("#username").val();
            	if ( $.trim(username) == "" ) {
					layer.msg("用户名称不能为空，请输入", {time:3000, icon:5, shift:6}, function(index){
						layer.close(index);
					});
            	    // 设定页面焦点
            	    $("#username").focus();
            	    return;
            	}
            	
            	var email = $("#email").val();
            	if ( $.trim(email) == "" ) {
					layer.msg("用户邮箱地址不能为空，请输入", {time:3000, icon:5, shift:6}, function(index){
						layer.close(index);
					});
            	    // 设定页面焦点
            	    $("#email").focus();
            	    return;
            	}
            	
            	// 提交表单
            	$("#userForm").submit();
            }
            
            function doReset() {
            	// jQuery对象的表单中没有重置方法（reset）
            	// DOM表单对象中有重置方法（reset）
            	// jQuery[0] => DOM
            	// $(DOM)    => jQuery
            	$("#userForm")[0].reset();
            }
        </script>
  </body>
</html>

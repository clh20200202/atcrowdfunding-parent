<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
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
      <input id="queryText" class="form-control has-success" type="text" placeholder="请输入查询条件">
    </div>
  </div>
  <button type="button" class="btn btn-warning" onclick="doQuery()"><i class="glyphicon glyphicon-search"></i> 查询</button>
</form>
<button type="button" class="btn btn-danger" style="float:right;margin-left:10px;" onclick="doBatchDelete()"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
<button type="button" class="btn btn-primary" style="float:right;" onclick="window.location.href='${PATH}/admin/add'"><i class="glyphicon glyphicon-plus"></i> 新增</button>
<br>
 <hr style="clear:both;">
          <div class="table-responsive">
            <table class="table  table-bordered">
              <thead>
                <tr >
                  <th width="30">#</th>
				  <th width="30"><input type="checkbox" onclick="doSelectBox()"></th>
                  <th>账号</th>
                  <th>名称</th>
                  <th>邮箱地址</th>
                  <th width="100">操作</th>
                </tr>
              </thead>
              <tbody>
                 <c:forEach items="${pageInfo.list}" var="admin" varStatus="status">
	                <tr>
	                  <td>${status.count}</td>
					  <td><input type="checkbox" value="${admin.id}"></td>
	                  <td>${admin.loginacct}</td>
	                  <td>${admin.username}</td>
	                  <td>${admin.email}</td>
	                  <td>
					      <button type="button" class="btn btn-success btn-xs" onclick="window.location.href='${PATH}/admin/assignRole?id=${admin.id}'"><i class=" glyphicon glyphicon-check"></i></button>
					      <button type="button" class="btn btn-primary btn-xs" onclick="doUpdateAdmin(${admin.id})"><i class=" glyphicon glyphicon-pencil"></i></button>
						  <button type="button" class="btn btn-danger btn-xs" onclick="doRemoveAdmin(${admin.id}, '${admin.loginacct}')"><i class=" glyphicon glyphicon-remove"></i></button>
					  </td>
	                </tr>
                 </c:forEach>
              </tbody>
			  <tfoot>
			     <tr >
				     <td colspan="6" align="center">
						<ul class="pagination">
						    <c:if test="${pageInfo.hasPreviousPage}">
						    <li><a style="cursor:pointer;" onclick="window.location.href='${PATH}/admin/index?pageno=${pageInfo.pageNum-1}'">上一页</a></li>
						    </c:if>
						    <c:forEach items="${pageInfo.navigatepageNums}" var="pn">
						        <c:if test="${pageInfo.pageNum == pn}">
						        <li class="active"><a style="cursor:pointer;" onclick="window.location.href='${PATH}/admin/index?pageno=${pn}'">${pn}</a></li>
						        </c:if>
						        <c:if test="${pageInfo.pageNum != pn}">
						        <li><a style="cursor:pointer;" onclick="window.location.href='${PATH}/admin/index?pageno=${pn}'">${pn}</a></li>
						        </c:if>
						    </c:forEach>
							<c:if test="${pageInfo.hasNextPage}">
								<li><a style="cursor:pointer;" onclick="window.location.href='${PATH}/admin/index?pageno=${pageInfo.pageNum+1}'">下一页</a></li>
							</c:if>
							
						 </ul>
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

            function doQuery() {
            	window.location.href = "${PATH}/admin/index?content=" + $("#queryText").val()
            }
            
            function doUpdateAdmin(id) {
            	window.location.href = "${PATH}/admin/edit?pageno=${pageInfo.pageNum}&id="+id
            }
            
            function doRemoveAdmin(id, loginacct) {
    			layer.confirm("删除用户["+loginacct+"]信息，是否继续?",  {icon: 3, title:'提示'}, function(cindex){
    			    // 确定按钮
    			    window.location.href = "${PATH}/admin/remove?id="+id
    				layer.close(cindex);
    			}, function(cindex){
    				// 取消按钮
    			    layer.close(cindex);
    			});
            }
            
            function doSelectBox() {
            	var flg = $("thead :checkbox")[0].checked;
            	//obj.checked
            	
            	$.each($("tbody :checkbox"), function(i, box){
            		box.checked = flg;
            	})
            }
            
            function doBatchDelete() {
            	var checkedBox = $("tbody :checked");
            	
            	if ( checkedBox.length == 0 ) {
            		layer.msg("请选择需要删除的数据", {time:2000, icon:5, shift:6}, function(index){
            			layer.close(index);
            		});
            	} else {
        			layer.confirm("删除选择的用户信息，是否继续?",  {icon: 3, title:'提示'}, function(cindex){
        			    
        				var ids = "";
        				
        				$.each( checkedBox, function(i, box){
        					var id = box.value
        					if ( i != 0 ) {
        						ids = ids + ",";
        					}
        					ids = ids + id;
        				} );
        				
        				// 确定按钮
        			    window.location.href = "${PATH}/admin/batchremove?ids=" + ids
        				layer.close(cindex);
        			}, function(cindex){
        				// 取消按钮
        			    layer.close(cindex);
        			});
            	}
            }
        </script>
  </body>
</html>

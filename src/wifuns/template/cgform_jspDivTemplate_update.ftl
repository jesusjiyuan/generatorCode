<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<#assign callbackFlag = false />
<#assign fileName = "" />
<#list pageColumns as callBackTestPo>
	<#if callBackTestPo.showType=='file'>
		<#assign callbackFlag = true />
	</#if>
</#list>
<html>
 <head>
  <title>${ftl_description}</title>
  <t:base type="jquery,easyui,tools,DatePicker"></t:base>
  <#if callbackFlag == true>
		<link rel="stylesheet" href="../plug-in/uploadify/css/uploadify.css" type="text/css" />
		<script type="text/javascript" src="../plug-in/uploadify/jquery.uploadify-3.1.js"></script>
  </#if>
 </head>
 <body>
  <t:formvalid formid="formobj" dialog="true" usePlugin="password" layout="div" action="${entityName?uncap_first}Controller.do?doUpdate" tiptype="1" ${callbackFlag?string("callback=\"jeecgFormFileCallBack@Override\"", "")}>
		<#list columns as po>
			<#if po.isShow == 'N'>
				<input id="${po.fieldName}" name="${po.fieldName}" type="hidden" value="${'$'}{${entityName?uncap_first}Page.${po.fieldName} }">
			</#if>
		</#list>
		<fieldset class="step">
		<#list columns as po>
			<#if po.isShow == 'Y'>
			<div class="form">
		      <label class="Validform_label">${po.content}:</label>
		       <#if po.showType=='text'>
		     	 <input id="${po.fieldName}" name="${po.fieldName}" type="text" style="width: 150px" class="inputxt"<#if po.fieldValidType?if_exists?html != ''> datatype="${po.fieldValidType?if_exists?html}"<#else><#if po.type == 'int'> datatype="n"<#elseif po.type=='double'> datatype="/^(-?\d+)(\.\d+)?$/"<#else><#if po.isNull != 'Y'>datatype="*"</#if></#if></#if>  value='${'$'}{${entityName?uncap_first}Page.${po.fieldName}}'>
		      <#elseif po.showType=='popup'>
			<input id="${po.fieldName}" name="${po.fieldName}" type="text" style="width: 150px" class="searchbox-inputtext" value='${'$'}{${entityName?uncap_first}Page.${po.fieldName}}' <#if po.fieldValidType?if_exists?html != ''>datatype="${po.fieldValidType?if_exists?html}" <#else><#if po.type == 'int'>datatype="n" <#elseif po.type=='double'>datatype="/^(-?\d+)(\.\d+)?$/" <#else><#if po.isNull != 'Y'>datatype="*" </#if></#if></#if><#if po.dictTable?if_exists?html!="">onclick="inputClick(this,'${po.dictField}','${po.dictTable}')"</#if> value='${'$'}{${entityName?uncap_first}Page.${po.fieldName}}'>			 
			  <#elseif po.showType=='textarea'>
			    <textarea id="${po.fieldName}" style="width:600px;" class="inputxt" rows="6" name="${po.fieldName}">${'$'}{${entityName?uncap_first}Page.${po.fieldName}}</textarea>
		      <#elseif po.showType=='password'>
		      	<input id="${po.fieldName}" name="${po.fieldName}" type="password" style="width: 150px" class="inputxt"<#if po.fieldValidType?if_exists?html != ''> datatype="${po.fieldValidType?if_exists?html}"<#else><#if po.type == 'int'> datatype="n"<#elseif po.type=='double'> datatype="/^(-?\d+)(\.\d+)?$/"<#else><#if po.isNull != 'Y'>datatype="*"</#if></#if></#if>  value='${'$'}{${entityName?uncap_first}Page.${po.fieldName}}'>
				<#elseif po.showType=='radio' || po.showType=='select' || po.showType=='checkbox' || po.showType=='list'>	 
					<t:dictSelect field="${po.fieldName}" type="${po.showType?if_exists?html}"
										<#if po.dictTable?if_exists?html != ''>dictTable="${po.dictTable?if_exists?html}" dictField="${po.dictField?if_exists?html}" dictText="${po.dictText?if_exists?html}"<#else>typeGroupCode="${po.dictField}"</#if> defaultVal="${'$'}{${entityName?uncap_first}Page.${po.fieldName}}" hasLabel="false"  title="${po.content}"></t:dictSelect>     
				<#elseif po.showType=='date'>
					  <input id="${po.fieldName}" name="${po.fieldName}" type="text" style="width: 150px" class="Wdate" onClick="WdatePicker()"<#if po.fieldValidType?if_exists?html != ''> datatype="${po.fieldValidType?if_exists?html}"<#else><#if po.isNull != 'Y'>datatype="*"</#if></#if>
		      						 value='<fmt:formatDate value='${'$'}{${entityName?uncap_first}Page.${po.fieldName}}' type="date" pattern="yyyy-MM-dd"/>'>    
		      	<#elseif po.showType=='datetime'>
					  <input id="${po.fieldName}" name="${po.fieldName}" type="text" style="width: 150px" 
		      						 class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"<#if po.fieldValidType?if_exists?html != ''> datatype="${po.fieldValidType?if_exists?html}"<#else><#if po.isNull != 'Y'>datatype="*"</#if></#if>
		      						 value='<fmt:formatDate value='${'$'}{${entityName?uncap_first}Page.${po.fieldName}}' type="date" pattern="yyyy-MM-dd hh:mm:ss"/>'>
		      	<#elseif po.showType=='file'>
					<table id="fileTable"></table>
					<#if !(po.operationCodesReadOnly ??)>
						<#assign fileName = "${po.fieldName}" />
						<table></table>
						<script type="text/javascript">
							var serverMsg="";
							$(function(){
								$('#${po.fieldName}').uploadify({
									buttonText:'添加文件',
									auto:false,
									progressData:'speed',
									multi:true,
									height:25,
									overrideEvents:['onDialogClose'],
									fileTypeDesc:'文件格式:',
									queueID:'filediv_file',
									fileTypeExts:'*.rar;*.zip;*.doc;*.docx;*.txt;*.ppt;*.xls;*.xlsx;*.html;*.htm;*.pdf;*.jpg;*.gif;*.png',
									fileSizeLimit:'15MB',
									swf:'../plug-in/uploadify/uploadify.swf',	
									uploader:'cgUploadController.do?saveFiles&jsessionid='+$("#sessionUID").val()+'',
									onUploadStart : function(file) { 
										var cgFormId=$("input[name='id']").val();
										$('#${po.fieldName}').uploadify("settings", "formData", {
											'cgFormId':cgFormId,
											'cgFormName':'${tableName}',
											'cgFormField':'${po.fieldName}'
										});
									} ,
									onQueueComplete : function(queueData) {
										 var win = frameElement.api.opener;
										 win.reloadTable();
										 win.tip(serverMsg);
										 frameElement.api.close();
									},
									onUploadSuccess : function(file, data, response) {
										var d=$.parseJSON(data);
										if(d.success){
											var win = frameElement.api.opener;
											serverMsg = d.msg;
										}
									},
									onFallback: function() {
					                    tip("您未安装FLASH控件，无法上传图片！请安装FLASH控件后再试")
					                },
					                onSelectError: function(file, errorCode, errorMsg) {
					                    switch (errorCode) {
					                    case - 100 : tip("上传的文件数量已经超出系统限制的" + $('#file').uploadify('settings', 'queueSizeLimit') + "个文件！");
					                        break;
					                    case - 110 : tip("文件 [" + file.name + "] 大小超出系统限制的" + $('#file').uploadify('settings', 'fileSizeLimit') + "大小！");
					                        break;
					                    case - 120 : tip("文件 [" + file.name + "] 大小异常！");
					                        break;
					                    case - 130 : tip("文件 [" + file.name + "] 类型不正确！");
					                        break;
					                    }
					                },
					                onUploadProgress: function(file, bytesUploaded, bytesTotal, totalBytesUploaded, totalBytesTotal) {}
								});
							});
						</script>
						<span id="file_uploadspan"><input type="file" name="${po.fieldName}" id="${po.fieldName}" /></span> 
						<div class="form" id="filediv_file"></div>
					</#if>
		      	<#else>
		      		<input id="${po.fieldName}" name="${po.fieldName}" type="text" style="width: 150px" class="inputxt"<#if po.fieldValidType?if_exists?html != ''> datatype="${po.fieldValidType?if_exists?html}"<#else><#if po.type == 'int'> datatype="n"<#elseif po.type=='double'> datatype="/^(-?\d+)(\.\d+)?$/"<#else><#if po.isNull != 'Y'>datatype="*"</#if></#if></#if>  value='${'$'}{${entityName?uncap_first}Page.${po.fieldName}}'>
				</#if>
		      <span class="Validform_checktip"></span>
		    </div>
			</#if>
			</#list>
	    </fieldset>
  </t:formvalid>
 </body>
  <script src = "webpage/${bussiPackage?replace('.','/')}/${entityPackage}/${entityName?uncap_first}.js"></script>		
  <#if callbackFlag == true>
  	<script type="text/javascript">
	  	//加载 已存在的 文件
	  	$(function(){
	  		var table = $("#fileTable");
	  		var cgFormId=$("input[name='id']").val();
	  		$.ajax({
	  		   type: "post",
	  		   url: "${entityName?uncap_first}Controller.do?getFiles&id=" +  cgFormId,
	  		   success: function(data){
	  			 var arrayFileObj = jQuery.parseJSON(data).obj;
	  			 
	  			$.each(arrayFileObj,function(n,file){
	  				var tr = $("<tr style=\"height:34px;\"></tr>");
	  				var td_title = $("<td>" + file.title + "</td>")
	  		  		var td_download = $("<td><a href=\"commonController.do?viewFile&fileid=" + file.fileKey + "&subclassname=org.jeecgframework.web.cgform.entity.upload.CgUploadEntity\" title=\"下载\">下载</a></td>")
	  		  		var td_view = $("<td><a href=\"javascript:void(0);\" onclick=\"openwindow('预览','commonController.do?openViewFile&fileid=" + file.fileKey + "&subclassname=org.jeecgframework.web.cgform.entity.upload.CgUploadEntity','fList',700,500)\">预览</a></td>");
	  		  		var td_del = $("<td><a href=\"javascript:void(0)\" class=\"jeecgDetail\" onclick=\"del('cgUploadController.do?delFile&id=" + file.fileKey + "',this)\">删除</a></td>");
	  		  		
	  		  		tr.appendTo(table);
	  		  		td_title.appendTo(tr);
	  		  		td_download.appendTo(tr);
	  		  		td_view.appendTo(tr);
	  		  		td_del.appendTo(tr);
	  			 });
	  		   }
	  		});
	  	})
  		function jeecgFormFileCallBack(data){
  			if (data.success == true) {
				uploadFile(data);
			} else {
				if (data.responseText == '' || data.responseText == undefined) {
					$.messager.alert('错误', data.msg);
					$.Hidemsg();
				} else {
					try {
						var emsg = data.responseText.substring(data.responseText.indexOf('错误描述'), data.responseText.indexOf('错误信息'));
						$.messager.alert('错误', emsg);
						$.Hidemsg();
					} catch(ex) {
						$.messager.alert('错误', data.responseText + '');
					}
				}
				return false;
			}
			if (!neibuClickFlag) {
				var win = frameElement.api.opener;
				win.reloadTable();
			}
  		}
  		function upload() {
			$('#${fileName}').uploadify('upload', '*');		
		}
		
		var neibuClickFlag = false;
		function neibuClick() {
			neibuClickFlag = true; 
			$('#btn_sub').trigger('click');
		}
		function cancel() {
			$('#${fileName}').uploadify('cancel', '*');
		}
		function uploadFile(data){
			if(!$("input[name='id']").val()){
				if(data.obj!=null && data.obj!='undefined'){
					$("input[name='id']").val(data.obj.id);
				}
			}
			if($(".uploadify-queue-item").length>0){
				upload();
			}else{
				if (neibuClickFlag){
					alert(data.msg);
					neibuClickFlag = false;
				}else {
					var win = frameElement.api.opener;
					win.reloadTable();
					win.tip(data.msg);
					frameElement.api.close();
				}
			}
		}
  	</script>
  </#if>
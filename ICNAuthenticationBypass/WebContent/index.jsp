<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>PoC ICN Authentication ByPass</title>

<script src="//ajax.googleapis.com/ajax/libs/dojo/1.11.2/dojo/dojo.js"></script>
<script>
	require(
		['dojo/dom', 'dojo/on', 'dojo/dom-construct', 'dojo/dom-style', 'dojo/domReady!'], 	    
	    function (dom, on, domConstruct, domStyle) {
	     		
			//Create an iframe where the authentication will happen
		    var iframe = domConstruct.create("iframe", {name: "authFrame", id: "authFrame", style: { width: "0%", height: "0%", display: "none" }}, dom.byId("icn"));

			//Variables to use. All them should be not here. Those values have to be ofuscated somehow.
			var basicUrl = "http://server/navigator/";
			var url = basicUrl + "jaxrs/logon";
			var desktop = "testing";
			var userid = "userid";
			var password = "password";
			
			//Form for authentication. Using Post and SSL.
			var form = domConstruct.create("form", {action: url, method: "post", target:"authFrame", style: { width: "0%", height: "0%", display: "none" }}, dom.byId("icn"));
				domConstruct.create("input", {name: "desktop", id:"desktop", value: desktop, type: "text"}, form);
				domConstruct.create("input", {name: "userid", id:"userid", value: userid, type: "text"}, form);
				domConstruct.create("input", {name: "password", id:"password", value: password, type: "password"}, form);
				var submit = domConstruct.create("input", {type: "button"}, form);
		   
			//Linking an event on submission and iframe reload.		   
		   on(submit, "click", function(){
			   form.submit();
			   
			   console.log("Submitting!");
			   
			 	//Once the iframe has loaded we consider authentication done
		       	on(iframe, "load", function(){
		        	console.log("Url loaded: " + url);
		        	
		        	//Open now the desired URL that will show the viewer
		        	var bookmark = basicUrl + "bookmark.jsp?desktop=testing&repositoryId=ZECMDOC01&repositoryType=p8" + 
		        			"&docid=Document%2C%7BACEC5A50-BF5D-41D5-AC93-CD921C59D056%7D%2C%7B3E7D19A4-6ED5-481A-9715-F47E39DEF670%7D&mimeType=application%2Fvnd.ms-powerpoint" +
		        			"&template_name=Document&version=released&vsId=%7BF0DF4A56-0000-C116-82E6-876CDB8612C6%7D";
		        	var viewer = domConstruct.create("iframe", {src: bookmark, style: { width: "100%", height: "600px", display: "none" }}, dom.byId("icn"), "first");
		        	
		        	//Once the DOM of the new iframe containing the bookmarked document is loaded then we show the iframe.
		        	on(viewer, "load", function(){
		        		domStyle.set(viewer, {display: "inline"});
		        		
		        		//Destroy the DOM node of the authentication iframe and the form.
			        	domConstruct.destroy(iframe);
			        	domConstruct.destroy(form);
		        	});
		        	
		        });
		   });
			
		 	//Submitting the form
			submit.click();
		}
	);
</script>

</head>
<body>

	<!-- Where the iframe will be built. -->
 	<div id="icn"></div>
 	
</body>
</html>
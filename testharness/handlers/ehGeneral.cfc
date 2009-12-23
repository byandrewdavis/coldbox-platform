<!-----------------------------------------------------------------------Author 	 :	Luis MajanoDate     :	September 25, 2005Description :	General handler for my hello application. Please remember to alter	your extends base component using the Coldfusion Mapping.	example:		Mapping: fwsample		Argument Type: fwsample.system.EventHandlerModification History:Sep/25/2005 - Luis Majano	-Created the template.-----------------------------------------------------------------------><cfcomponent extends="baseHandler" 			 output="false" 			 autowire="true"  			 autowire_setterinjection="false">	<!--- Autowire Properties --->	<cfproperty name="myMailSettings" 				type="ioc" 		scope="instance">	<cfproperty name="BogusIOC"		 				type="ioc" 		scope="instance">	<cfproperty name="ColdBox" 		  				type="coldbox" 	scope="instance">	<cfproperty name="ModelsPath" 				  	type="coldbox:setting:ModelsPath" 	scope="instance">	<cfproperty name="Utilities" 		  			type="coldbox:plugin:Utilities" 	scope="instance">	<cfproperty name="ConfigBean" 		  			type="coldbox:configbean" 			scope="instance">	<cfproperty name="MailSettingsBean" 		  	type="coldbox:mailsettingsBean" 	scope="instance">	<cfproperty name="MySiteDSN" 		  			type="coldbox:datasource:mysite" 	scope="instance">	<cfproperty name="bogusModel" 		  			type="model" 						scope="instance">	<cfproperty name="testModel" 		  			type="model" 						scope="instance">	<cfproperty name="testModelAlias" 		  		type="model:testModel" 				scope="instance">	<cfproperty name="initDate" 		  			type="model:formBean:getinitDate" 	scope="instance">	<!--- Services --->	<cfproperty name="requestService" 		  		type="coldbox:requestService" 		scope="instance">	<cfproperty name="pluginService" 		  		type="coldbox:pluginService" 		scope="instance">	<cfproperty name="handlerService" 		  		type="coldbox:handlerService" 		scope="instance">	<cfproperty name="debuggerService" 		  		type="coldbox:debuggerService" 		scope="instance">	<cfproperty name="interceptorService" 		  	type="coldbox:interceptorService" 	scope="instance">	<cfproperty name="loaderService" 		  		type="coldbox:loaderService" 		scope="instance">	<cfproperty name="cacheManager" 		  		type="coldbox:cacheManager" 		scope="instance">	<cfproperty name="TimeSlotService"				type="model"		scope="variables">		<!--- Log Box DSL --->	<cfproperty name="logBox" 		  		type="logBox" 		scope="instance">	<cfproperty name="rootLogger" 		  	type="logBox:root"	scope="instance">	<cfproperty name="myLogger"				type="logBox:logger"	scope="instance">		<!--- JavaLoader DSL --->	<cfproperty name="helloClass"			type="javaloader:HelloWorld" scope="instance" >		<!--- properties --->	<cfscript>		this.allowedMethods = {doFormBean="POST,GET"};	</cfscript>		<!--- onDIComplete --->
	<cffunction name="onDIComplete" output="false" access="public" returntype="any" hint="">
		<!---<cfdump var="#instance.myLogger.getCategory()#">		<cfabort>		--->
	</cffunction>	<cffunction name="dspHello" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.web.context.RequestContext">		<cfset var logger = controller.getPlugin("Logger")>	    <cfset var complexStruct = "">	    <cfset var complete = "">	    	    <cfscript>	    	fis = createObject("java","java.io.FileInputStream").init(expandPath("/coldbox/testharness/includes/style.css"));	    	fos = createObject("java","java.io.FileOutputStream").init(expandPath("/coldbox/testharness/includes/mypack.css"));	    		    	jsmin = getPlugin("JavaLoader").create("org.coldbox.JSMin");	    		    	jsmin.init(fis,fos);	    		    	jsmin.jsmin();	    		    	//$dump(jsmin,true);	    	    </cfscript>	    	    <cfset getPlugin("Timer").start("New Instance Creation")>				<!--- Get a new instance plugin --->		<cfset event.setValue("mylogger", getPlugin("Logger",false,true) )>		<cfset getPlugin("Timer").stop("New Instance Creation")>				<!--- Create a tracer message --->		<cfset logger.tracer("Starting dspHello. Using default name")>		<cfset logger.tracer("arguments: #arguments.toString()#")>				<!--- Set the firstname Value --->		<cfset Event.setValue("firstname",getSetting("Codename", true) & getSetting("Version", true))>		<cfset complete = isEmail("info@coldboxframework.com")>		<!--- Java Loader --->		<cfset Event.setvalue("HelloWorldObj", getPlugin("JavaLoader").create("HelloWorld").init())>				<!--- Create an info MessageBox --->		<cfset getPlugin("MessageBox").setMessage("info", "Hello and welcome to the ColdBox' message box. You can place messages here from any of your applications. You can also choose the desired image to display. You can set error message, warning messages or just plain informative messages like this one. You can do this by using the <b>MessageBox</b> plugin.")>		<!--- Get view contents ---->		<cfset Event.setValue("MyQuote", renderView("vwQuote"))>				<!--- Run Private Event --->		<cfset runEvent(event="ehGeneral.myPrivateEvent",private=true)>				<!--- Set the view to render --->		<cfset Event.setView(name="Hello")>	</cffunction>	<cffunction name="doChangeLocale" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.web.context.RequestContext">		<!--- Change Locale --->		<cfset controller.getPlugin("i18n").setfwLocale(Event.getValue("locale"))>		<cfset dspHello(Event)>	</cffunction>	<cffunction name="testflash" access="public" output="false" returntype="void">		<cfargument name="Event" type="coldbox.system.web.context.RequestContext">		<cfscript>		var rc = event.getCollection();		rc.lname = "majano";		rc.fname = "luis";		setNextEvent(event='ehGeneral.dspFlash',persist='lname,fname');		</cfscript>	</cffunction>		<cffunction name="dspFlash" access="public" output="false" returntype="void">		<cfargument name="Event" type="coldbox.system.web.context.RequestContext">		<cfscript>		var rc = event.getCollection();				event.setView("dspFlash");		</cfscript>	</cffunction>	<cffunction name="doLog" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.web.context.RequestContext">		<cfscript>		var logger = getPlugin("Logger");		var interceptorMetadata = structnew();				interceptorMetadata.name = "Luis Majano";		interceptorMetadata.currentDateTime = now();		announceInterception("onLog",interceptorMetadata);			logger.logEntry("error","This is an error message that I logged.","Home Portals is the best.");		logger.logEntry("information","This is an information message that I logged.");		logger.logEntry("warning","This is an warning message that I logged.");		logger.logEntry("fatal","The whole thing crashed man");		dspHello(Event);		</cfscript>	</cffunction>	<cffunction name="doClearLog" access="public" returntype="void" output="false">		<cfscript>		getPlugin("Utilities").removeFile(controller.getSetting("ExpandedColdboxLogsLocation"));		setnextevent("ehGeneral.dspHello","fwreinit=1");		</cfscript>	</cffunction>	<cffunction name="docustomplugin" access="public" returntype="void" output="false">		<cfset var stime = getTickcount()>		<cfset getMyPlugin("myclientstorage").setvar("MyCustomVariable","Custom Variable has been set by custom plugin at #timeformat(now(),"HH:MM:SS TT")#.")>		<cfset getPlugin("Logger").tracer("Testing Flash Persistance", "Total Execution Time: #getTickCount()-stime#")>		<cfset setNextEvent("","usecustomplugin=true")>	</cffunction>	<cffunction name="purgeEvents" access="public" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.web.context.RequestContext">		<cfscript>			getColdboxOCM().clearAllEvents();			setNextEvent();		</cfscript>	</cffunction>		<cffunction name="dspFolderTester1" access="public" returntype="void" output="false"  cache="true" cacheTimeout="5">		<cfargument name="Event" type="coldbox.system.web.context.RequestContext">		<cfscript>		var rc = Event.getCollection();		//external location;		event.setLayout("ext");		Event.setView("tags/test1");		</cfscript>	</cffunction>		<cffunction name="dspFolderTester2" access="public" returntype="void" output="false"  cache="true" cacheTimeout="5">		<cfargument name="Event" type="coldbox.system.web.context.RequestContext">		<cfscript>		var rc = Event.getCollection();		Event.setView("pdf/single/test");		</cfscript>	</cffunction>		<!--- externalView --->
	<cffunction name="externalView" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="coldbox.system.web.context.RequestContext" required="yes">
	    
	    <cfset event.setView('externalview')>	     
	</cffunction>		<!--- display login form (testing security interceptor) --->	<cffunction name="dspLogin" access="public" returntype="Void" output="false">		<cfargument name="Event" type="coldbox.system.web.context.RequestContext" required="yes">		<cfset var rc = event.getCollection()>		 <!--- testing secure handlers/methods --->		<cfset event.setView('vwLoginForm')>	</cffunction>		<!--- dumpsettings --->	<cffunction name="dumpsettings" access="public" returntype="void" output="false" hint="">		<cfargument name="Event" type="any" required="yes">	</cffunction>	<!------------------------------------------- PRIVATE METHDOS ------------------------------------------->		<cffunction name="getmyMailSettings" access="public" output="false" returntype="any" hint="Get myMailSettings">
		<cfreturn instance.myMailSettings/>
	</cffunction>	
	<cffunction name="setmyMailSettings" access="public" output="false" returntype="void" hint="Set myMailSettings">
		<cfargument name="myMailSettings" type="any" required="true"/>
		<cfset instance.myMailSettings = arguments.myMailSettings/>
	</cffunction>			<cffunction name="myPrivateEvent" access="private" returntype="void" output="false">		<cfargument name="Event" type="coldbox.system.web.context.RequestContext">		<cfscript>		var rc = Event.getCollection();		/* Private */		rc.privateEventCalled = true;		</cfscript>	</cffunction>	</cfcomponent>
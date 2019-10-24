#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // Create an instance of AloeExpress.Server, and configure it with optional command-line arguments.
		  Dim Server As New AloeExpress.Server(args)
		  
		  // Configure server-level session management. 
		  // This is used by the DemoSessions demo module.
		  Server.SessionsEnabled = True
		  
		  // Configure server-level caching.
		  // This is used by the DemoCaching demo module.
		  Server.CachingEnabled = True
		  
		  //Pass any additional information to be displayed with Server.ServerInfoDisplay
		  //Dim info As New Dictionary
		  //info.Value( "My App Version" ) = App.MajorVersion.ToString + "." + App.MinorVersion.ToString + "." + App.BugVersion.ToString
		  //Server.AdditionalServerDisplayInfo = info
		  
		  // Start the server.
		  Server.Start
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub RequestHandler(Request As AloeExpress.Request)
		  // Processes an HTTP request.
		  
		  // Uncomment the demo module that you want to use.
		  'Break
		  
		  // Hello, world demo.
		  DemoHelloWorld.RequestProcess(Request)
		  // Or simply...
		  'Request.Response.Content = "Hello, world!"
		  
		  // AloeExpress.CacheEngine.
		  'DemoCaching.RequestProcess(Request)
		  
		  // AloeExpress.Logger.
		  'DemoLogging.RequestProcess(Request)
		  
		  // Multipart forms demo.
		  'DemoMultipartForms.RequestProcess(Request)
		  
		  // AloeExpress.SessionEngine.
		  'DemoSessions.RequestProcess(Request)
		  
		  // Demonstrates the use of client-side templating.
		  'DemoTemplatesClientSide.RequestProcess(Request)
		  
		  // Demonstrates the use of server-side templates.
		  'DemoTemplatesServerSide.RequestProcess(Request)
		  
		  // A simple chat app that demonstrates WebSocket support.
		  'DemoWebSockets.RequestProcess(Request)
		  
		  // Demonstrates Xojoscript support.
		  'DemoXojoScript.RequestProcess(Request)
		  
		  // AloeExpress.ServerThread demo.
		  // *** Before using this demo... *** 
		  // Replace the App.Run event handler with this: 
		  // DemoServerThreads.ServersLaunch
		  // Test ports are: 64000, 64001, 64002, and 64003.
		  // Requests sent to 64003 will respond with an error,
		  // to demonstrate a misconfigured app.
		  'DemoServerThreads.RequestProcess(Request)
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass

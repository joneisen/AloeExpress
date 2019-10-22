#tag Module
Protected Module DemoTemplatesClientSide
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As AloeExpress.Request)
		  // By default, the Request.StaticPath points to an "htdocs" folder.
		  // In this example, we're using an alternate folder.
		  Request.StaticPath = App.ExecutableFile.Parent.Parent.Child("htdocs").Child("demo-templates-client-side")
		  
		  // Process the request based on the path of the requested resource...
		  If Request.Path = "/data" Then
		    
		    // Simulate a slow query.
		    App.SleepCurrentThread(500)
		    
		    // Get the orders.
		    Dim Orders As String = AloeExpress.FileRead(Request.StaticPath.Parent.Parent.Child("data").Child("orders.json"))
		    
		    // Create the data object.
		    Dim Data As New JSONItem(Orders)
		    Data.Value("system") = SystemDataGet(Request)
		    
		    // Return the data as a JSON string.
		    Request.Response.Content = Data.ToString
		    
		    // Specify the response content type.
		    Request.Response.Headers.Value("Content-Type") = "application/json"
		    
		  Else
		    
		    // Map the request to a file.
		    Request.MapToFile
		    
		    // If the request couldn't be mapped to a static file...
		    If Request.Response.Status = "404" Then
		      
		      // Return the standard 404 error response.
		      // You could also use a custom error handler that sets Request.Response.Content.
		      Request.ResourceNotFound
		      
		    Else
		      
		      // Set the Cache-Control header value so that static content is cached for 1 hour.
		      Request.Response.Headers.Value("Cache-Control") = "public, max-age=3600"
		      
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SystemDataGet(Request As AloeExpress.Request) As JSONItem
		  // Add the Date object.
		  Dim DateData As New JSONItem
		  Dim Today As DateTime = DateTime.Now
		  DateData.Value("abbreviateddate") = Today.ToString( Nil, DateTime.FormatStyles.Medium, DateTime.FormatStyles.None )
		  DateData.Value("day") = Today.Day.ToString
		  DateData.Value("dayofweek") = Today.DayOfWeek.ToString
		  DateData.Value("dayofyear") = Today.DayOfYear.ToString
		  Dim GMTOffset As Double = Today.Timezone.SecondsFromGMT / 3600 //3600 seconds in an hour
		  DateData.Value("gmtoffset") = GMTOffset.ToString
		  DateData.Value("hour") = Today.Hour.ToString
		  DateData.Value("longdate") = Today.ToString( Nil, DateTime.FormatStyles.Long, DateTime.FormatStyles.None )
		  DateData.Value("longtime") = Today.ToString( Nil, DateTime.FormatStyles.None, DateTime.FormatStyles.Medium ) // This is the closest equivalent to the old code. We might have to trip the AM and PM off the end
		  DateData.Value("minute") = Today.Minute.ToString
		  DateData.Value("month") = Today.Month.ToString
		  DateData.Value("second") = Today.Second.ToString
		  DateData.Value("shortdate") = Today.ToString( Nil, DateTime.FormatStyles.Short, DateTime.FormatStyles.None )
		  DateData.Value("shorttime") = Today.ToString( Nil, DateTime.FormatStyles.None, DateTime.FormatStyles.Short )
		  DateData.Value("sql") = Today.SQLDate
		  DateData.Value("sqldate") = Today.SQLDate
		  DateData.Value("sqldatetime") = Today.SQLDateTime
		  DateData.Value("SecondsFrom1970") = Today.SecondsFrom1970
		  DateData.Value("weekofyear") = Today.WeekOfYear.ToString
		  DateData.Value("year") = Today.Year.ToString
		  
		  // Add the Meta object.
		  Dim MetaData As New JSONItem
		  MetaData.Value("xojo-version") = XojoVersionString
		  MetaData.Value("aloe-version") = AloeExpress.VersionString
		  
		  // Add the Request object.
		  Dim RequestData As New JSONItem
		  RequestData.Value("cookies") = DictionaryToJSONItem(Request.Cookies)
		  RequestData.Value("data") = Request.Data
		  RequestData.Value("get") = DictionaryToJSONItem(Request.GET)
		  RequestData.Value("headers") = DictionaryToJSONItem(Request.Headers)
		  RequestData.Value("method") = Request.Method
		  RequestData.Value("path") = Request.Path
		  RequestData.Value("post") = DictionaryToJSONItem(Request.POST)
		  RequestData.Value("remoteaddress") = Request.RemoteAddress
		  RequestData.Value("socketid") = Request.SocketID.ToString
		  RequestData.Value("urlparams") = Request.URLParams
		  
		  // Create the system object.
		  Dim SystemData As New JSONItem
		  SystemData.Value("date") = DateData
		  SystemData.Value("meta") = MetaData
		  SystemData.Value("request") = RequestData
		  
		  Return SystemData
		  
		  
		  
		  
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule

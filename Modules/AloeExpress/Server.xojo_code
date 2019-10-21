#tag Class
Protected Class Server
Inherits ServerSocket
	#tag Event
		Function AddSocket() As TCPSocket
		  // Tries to add a socket to the pool.
		  Try
		    
		    // Increment the Socket ID.
		    CurrentSocketID = CurrentSocketID + 1
		    
		    // Create a new instance of Request to act as the socket, and assign it an ID.
		    Dim NewSocket As New Request(Self)
		    NewSocket.SocketID = CurrentSocketID
		    
		    // Append the socket to the array.
		    Sockets.Append(NewSocket)
		    
		    // Return the socket.
		    Return NewSocket
		    
		  Catch e As RunTimeException
		    
		    Dim TypeInfo As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(e)
		    
		    System.DebugLog "Aloe Express Server Error: Unable to Add Socket w/ID " + CurrentSocketID.ToText
		    
		  End Try
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Error(ErrorCode As Integer, err As RuntimeException)
		  System.DebugLog "Aloe Express Server Error: Code: " + ErrorCode.ToText
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(Args() As String = Nil)
		  // Set defaults.
		  Port = 8080
		  MaximumSocketsConnected = 200
		  MinimumSocketsAvailable = 50
		  Secure = False
		  ConnectionType = SSLSocket.TLSv12
		  CertificateFile = GetFolderItem("").Parent.Child("certificates").Child("default-certificate.crt")
		  CertificatePassword = ""
		  KeepAlive = True
		  
		  // If arguments were passed...
		  If Args <> Nil Then
		    
		    // Convert any command line arguments into a dictionary.
		    Dim Arguments As Dictionary = ArgsToDictionary(Args)
		    
		    // Assign valid arguments to their corresponding properties...
		    
		    If Arguments.HasKey("--Port") Then
		      Port = Val(Arguments.Value("--Port"))
		    End If
		    
		    If Arguments.HasKey("--MaxSockets") Then
		      MaximumSocketsConnected = Val(Arguments.Value("--MaxSockets"))
		    End If
		    
		    If Arguments.HasKey("--MinSockets") Then
		      MinimumSocketsAvailable = Val(Arguments.Value("--MinSockets"))
		    End If
		    
		    Loopback = Arguments.HasKey("--Loopback")
		    
		    If Arguments.HasKey("--Nothreads") Then 
		      Multithreading = False
		    End If
		    
		    If Arguments.HasKey("--Secure") Then 
		      Secure = True
		    End If
		    
		    If Arguments.HasKey("--ConnectionType") Then 
		      ConnectionType = Val(Arguments.Value("--ConnectionType"))
		    End If
		    
		    If Arguments.HasKey("--CertificateFile") Then 
		      CertificateFile = New FolderItem(Arguments.Value("--CertificateFile"), 1)
		    End If
		    
		    If Arguments.HasKey("--CertificatePassword") Then 
		      CertificatePassword = CertificatePassword
		    End If
		    
		    If Arguments.HasKey("--CloseConnections") Then 
		      KeepAlive = False
		    End If
		    
		  End If
		  
		  // Initlialize the Custom dictionary.
		  Custom = New Dictionary
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ServerInfoDisplay()
		  // Displays server configuration info.
		  
		  Dim Info As String = EndOfLine + EndOfLine _
		  + Name + " has started... " + EndOfLine _
		  + "• Xojo Version: " + XojoVersionString + EndOfLine _
		  + "• Aloe Express Version: " + AloeExpress.VersionString + EndOfLine _
		  + "• Caching: " + If(CachingEnabled , "Enabled", "Disabled") + EndOfLine _
		  + "• Cache Sweep Interval: " + CacheSweepIntervalSecs.ToText + " seconds" + EndOfLine _
		  + "• Loopback: " + If(Loopback , "Enabled", "Disabled") + EndOfLine _
		  + "• Keep-Alives: " + If(KeepAlive , "Enabled", "Disabled") + EndOfLine _
		  + "• Keep-Alive Timeout: " + KeepAliveTimeout.ToText  + " seconds" + EndOfLine _
		  + "• Keep-Alive Sweep Interval: " + ConnSweepIntervalSecs.ToText + EndOfLine _
		  + "• Maximum Entity Size: " + MaxEntitySize.ToText + EndOfLine _
		  + "• Maximum Sockets Connected: " + MaximumSocketsConnected.ToText + EndOfLine _
		  + "• Minimum Sockets Available: " + MinimumSocketsAvailable.ToText + EndOfLine _
		  + "• Multithreading: " + If(Multithreading, "Enabled", "Disabled") + EndOfLine _
		  + "• Port: " + Port.ToText + EndOfLine _
		  + "• Sessions: " + If(SessionsEnabled , "Enabled", "Disabled") + EndOfLine _
		  + "• Sessions Sweep Interval: " + SessionsSweepIntervalSecs.ToText + " seconds" + EndOfLine _
		  + "• SSL: " + If(Secure , "Enabled", "Disabled") + EndOfLine _
		  + If(Secure , "• SSL Certificate Path: " + CertificateFile.NativePath + EndOfLine, "") _
		  + If(Secure , "• SSL Connection Type: " + ConnectionType.ToText  + EndOfLine, "") _
		  + "• WebSocket Timeout: " + WSTimeout.ToText + " seconds" + EndOfLine _
		  + EndOfLine + EndOfLine
		  
		  System.DebugLog Info + EndOfLine + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start()
		  // Starts the server so that it listens for incoming requests.
		  
		  
		  // If the server should use the loopback network interface.
		  If Loopback Then
		    NetworkInterface = NetworkInterface.Loopback
		  End If
		  
		  // Create a ConnectionSweeper timer object for this server.
		  Dim Sweeper As New ConnectionSweeper(Self)
		  
		  // If caching is enabled...
		  If CachingEnabled Then
		    CacheEngine = New AloeExpress.CacheEngine(CacheSweepIntervalSecs)
		  End If
		  
		  // If session management is enabled...
		  If SessionsEnabled Then
		    SessionEngine = New AloeExpress.SessionEngine(SessionsSweepIntervalSecs)
		  End If
		  
		  // Start listening for incoming requests.
		  Listen
		  
		  // If the server is running as part of a desktop app...
		  #If TargetDesktop Then
		    // We're done.
		    Return
		  #Endif
		  
		  // If the server isn't starting silently...
		  If SilentStart = False Then
		    // Display server info.
		    ServerInfoDisplay
		  End If
		  
		  // Rock on.
		  While True
		    app.DoEvents
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WSMessageBroadcast(Message As String)
		  // Broadcasts a message to all of the WebSockets that are connected to the server.
		  
		  
		  // Loop over each WebSocket connection...
		  For Each Socket As AloeExpress.Request In WebSockets
		    
		    // If the WebSocket is still connected...
		    If Socket.IsConnected Then
		      
		      // Send it the message.
		      Socket.WSMessageSend(Message)
		      
		    End If
		    
		  Next
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		CacheEngine As AloeExpress.CacheEngine
	#tag EndProperty

	#tag Property, Flags = &h0
		CacheSweepIntervalSecs As Integer = 300
	#tag EndProperty

	#tag Property, Flags = &h0
		CachingEnabled As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		CertificateFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		CertificatePassword As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ConnectionType As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ConnSweepIntervalSecs As Integer = 15
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentSocketID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Custom As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		KeepAlive As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		KeepAliveTimeout As Integer = 30
	#tag EndProperty

	#tag Property, Flags = &h0
		Loopback As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		MaxEntitySize As Integer = 10485760
	#tag EndProperty

	#tag Property, Flags = &h0
		Multithreading As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String = "Aloe Express Server"
	#tag EndProperty

	#tag Property, Flags = &h0
		Secure As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		SessionEngine As AloeExpress.SessionEngine
	#tag EndProperty

	#tag Property, Flags = &h0
		SessionsEnabled As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		SessionsSweepIntervalSecs As Integer = 300
	#tag EndProperty

	#tag Property, Flags = &h0
		SilentStart As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Sockets() As Request
	#tag EndProperty

	#tag Property, Flags = &h0
		WebSockets() As AloeExpress.Request
	#tag EndProperty

	#tag Property, Flags = &h0
		WSTimeout As Integer = 1800
	#tag EndProperty


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
			InitialValue=""
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
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumSocketsAvailable"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumSocketsConnected"
			Visible=true
			Group="Behavior"
			InitialValue="10"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentSocketID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Loopback"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Multithreading"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Secure"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ConnectionType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CertificatePassword"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaxEntitySize"
			Visible=false
			Group="Behavior"
			InitialValue="10485760"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeepAlive"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeepAliveTimeout"
			Visible=false
			Group="Behavior"
			InitialValue="60"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ConnSweepIntervalSecs"
			Visible=false
			Group="Behavior"
			InitialValue="60"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SilentStart"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="WSTimeout"
			Visible=false
			Group="Behavior"
			InitialValue="1800"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CachingEnabled"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionsEnabled"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CacheSweepIntervalSecs"
			Visible=false
			Group="Behavior"
			InitialValue="300"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionsSweepIntervalSecs"
			Visible=false
			Group="Behavior"
			InitialValue="300"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

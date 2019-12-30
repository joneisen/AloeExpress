#tag Class
Protected Class ConnectionSweeper
Inherits Timer
	#tag Event
		Sub Action()
		  // Closes any HTTP connections that have timed out.
		  HTTPConnSweep
		  
		  // Closes any WebSocket connections that have timed out.
		  WSConnSweep
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(Server As AloeExpress.Server)
		  // Store the server.
		  Self.Server = Server
		  
		  // Schedule the Sweep process.
		  Period = Server.ConnSweepIntervalSecs * 1000
		  RunMode = Timer.RunModes.Multiple
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HTTPConnSweep()
		  // Closes connections that have timed out.
		  
		  
		  // Loop over the server's connections...
		  For Each Socket As AloeExpress.Request in Server.Sockets
		    
		    // If the socket isn't connected...
		    If Socket.IsConnected = False Then
		      Continue
		    End If
		    
		    // If the socket has not been connected to...
		    If Socket.LastConnect = Nil Then
		      Continue
		    End If
		    
		    // If the socket is actively servicing a WebSocket...
		    If Socket.WSStatus = "Active" Then
		      Continue
		    End If
		    
		    // Get the current date/time.
		    Dim Now As DateTime = DateTime.Now
		    
		    // Get the socket's last connection timestamp.
		    Dim Timeout As DateTime = Socket.LastConnect
		    
		    // Determine when the connection will timeout due to inactivity.
		    //years, months, days, hours, minutes, seconds
		    Timeout = Timeout.AddInterval(  0, 0, 0, 0, 0,  Server.KeepAliveTimeout )
		    
		    // If the socket's keep-alive has timed out...
		    If Now > Timeout Then
		      
		      // Reset the socket's last connection time.
		      Socket.LastConnect = Nil
		      
		      // Close the socket.
		      Socket.Close
		      
		    End If
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WSConnSweep()
		  // Closes WebSocket connections that have timed out.
		  
		  // If the server has been configured so that WebSocket connections do not timeout...
		  If Server.WSTimeout = 0 Then
		    Return
		  End If
		  
		  // Loop over the server's WebSockets...
		  For i As Integer = Server.WebSockets.LastRowIndex DownTo 0
		    
		    // Get the socket.
		    Dim Socket As AloeExpress.Request = Server.WebSockets(i)
		    
		    // Get the current date/time.
		    Dim Now As DateTime = DateTime.Now
		    
		    // Get the socket's last connection timestamp.
		    Dim Timeout As DateTime = Socket.LastConnect
		    
		    // Determine when the connection will timeout due to inactivity.
		    //years, months, days, hours, minutes, seconds
		    Timeout = Timeout.AddInterval( 0, 0, 0, 0, 0, Server.WSTimeout )
		    
		    // If the socket has timed out...
		    If Now > Timeout Then
		      
		      // Reset the socket's last connection time.
		      Socket.LastConnect = Nil
		      
		      // Set the WebSocket status.
		      Socket.WSStatus = "Inactive"
		      
		      // Close the socket.
		      Socket.Close
		      
		      // Remove the socket from the array.
		      Server.WebSockets.RemoveRowAt(i)
		      
		    End If
		    
		  Next
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Server As AloeExpress.Server
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="RunMode"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="RunModes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Off"
				"1 - Single"
				"2 - Multiple"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Period"
			Visible=true
			Group="Behavior"
			InitialValue="1000"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
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
	#tag EndViewBehavior
End Class
#tag EndClass

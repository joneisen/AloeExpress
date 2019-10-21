#tag Class
Protected Class RequestThread
Inherits Thread
	#tag Event
		Sub Run()
		  // Processes a request.
		  
		  
		  Dim Request As AloeExpress.Request
		  
		  If ( RequestWR <> Nil ) And ( RequestWR.Value <> Nil ) And ( RequestWR.Value IsA AloeExpress.Request ) Then
		    
		    Request = AloeExpress.Request( RequestWR.Value )
		    
		    Request.Process
		    
		  End If
		  
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h0
		RequestWR As WeakRef
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
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

#tag Module
Protected Module Extensions
	#tag Method, Flags = &h0
		Function ToString(extends s as SSLSocket.SSLConnectionTypes) As String
		  Dim output As String
		  Select Case s
		  Case SSLSocket.SSLConnectionTypes.SSLv23
		    output = "SSL version 3"
		  Case SSLSocket.SSLConnectionTypes.TLSv1
		    output = "TLS version 1" 
		  Case SSLSocket.SSLConnectionTypes.TLSv11
		    output = "TLS version 1.1"
		  Case SSLSocket.SSLConnectionTypes.TLSv12
		    output = "TLS version 1.2"
		  Else
		    Raise New Xojo.Core.BadDataException
		  End Select
		End Function
	#tag EndMethod


End Module
#tag EndModule

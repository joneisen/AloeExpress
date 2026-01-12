#tag Module
Protected Module TestPerformanceTests
	#tag Method, Flags = &h0
		Sub TestWebSocketPayloadProcessing(ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Test WebSocket payload processing performance

		  System.DebugLog("  Testing WebSocket payload processing...")

		  // Test old concatenation method vs new optimized method
		  Dim testData() As Integer
		  Dim maskKey() As Integer = Array(1, 2, 3, 4)

		  // Create test payload of 10KB
		  For i As Integer = 0 To 10239
		    testData.AddRow(65 + (i Mod 26)) // ASCII letters
		  Next

		  // OLD METHOD (String concatenation in loop) - SLOW
		  Dim startTime As Double = Microseconds
		  Dim oldResult As String = ""
		  For i As Integer = 0 To testData.LastRowIndex
		    oldResult = oldResult + Chr(testData(i) XOR maskKey(i Mod 4))
		  Next
		  Dim oldTime As Double = (Microseconds - startTime) / 1000.0

		  // NEW METHOD (Array of strings + Join) - FAST
		  startTime = Microseconds
		  Dim newResult() As String
		  For i As Integer = 0 To testData.LastRowIndex
		    newResult.AddRow(Chr(testData(i) XOR maskKey(i Mod 4)))
		  Next
		  Dim finalResult As String = String.FromArray(newResult, "")
		  Dim newTime As Double = (Microseconds - startTime) / 1000.0

		  System.DebugLog("    Old method (concatenation): " + Format(oldTime, "##0.00") + " ms")
		  System.DebugLog("    New method (array + join): " + Format(newTime, "##0.00") + " ms")
		  System.DebugLog("    Performance improvement: " + Format((oldTime / newTime), "##0.00") + "x faster")

		  TestHelpers.AssertTrue(newTime < oldTime, "New method is faster than old method", totalTests, passedTests, failedTests)
		  TestHelpers.AssertEquals(oldResult, finalResult, "Both methods produce same result", totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TestDumpMethodPerformance(ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Test Dump() method performance with large dictionaries

		  System.DebugLog("  Testing Dump() method performance...")

		  // Create test dictionary
		  Dim testDict As New Dictionary

		  For i As Integer = 1 To 100
		    testDict.Value("Header" + i.ToString) = "Value" + i.ToString
		  Next

		  // OLD METHOD (String concatenation)
		  Dim startTime As Double = Microseconds
		  Dim oldHTML As String = ""
		  oldHTML = oldHTML + "<ul>"
		  For Each key As Variant In testDict.Keys
		    oldHTML = oldHTML + "<li>" + key.StringValue + "=" + testDict.Value(key).StringValue + "</li>"
		  Next
		  oldHTML = oldHTML + "</ul>"
		  Dim oldTime As Double = (Microseconds - startTime) / 1000.0

		  // NEW METHOD (Array of strings)
		  startTime = Microseconds
		  Dim newHTML() As String
		  newHTML.AddRow("<ul>")
		  For Each key As Variant In testDict.Keys
		    newHTML.AddRow("<li>" + key.StringValue + "=" + testDict.Value(key).StringValue + "</li>")
		  Next
		  newHTML.AddRow("</ul>")
		  Dim finalHTML As String = String.FromArray(newHTML, "")
		  Dim newTime As Double = (Microseconds - startTime) / 1000.0

		  System.DebugLog("    Old method: " + Format(oldTime, "##0.00") + " ms")
		  System.DebugLog("    New method: " + Format(newTime, "##0.00") + " ms")

		  TestHelpers.AssertTrue(newTime <= oldTime * 1.5, "New method is comparable or better", totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TestStringConcatenationOptimization(ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Test general string concatenation optimization

		  System.DebugLog("  Testing string concatenation optimization...")

		  Const iterations As Integer = 1000

		  // OLD METHOD
		  Dim startTime As Double = Microseconds
		  Dim oldString As String = ""
		  For i As Integer = 1 To iterations
		    oldString = oldString + "x"
		  Next
		  Dim oldTime As Double = (Microseconds - startTime) / 1000.0

		  // NEW METHOD
		  startTime = Microseconds
		  Dim newStringArray() As String
		  For i As Integer = 1 To iterations
		    newStringArray.AddRow("x")
		  Next
		  Dim newString As String = String.FromArray(newStringArray, "")
		  Dim newTime As Double = (Microseconds - startTime) / 1000.0

		  System.DebugLog("    Old concatenation: " + Format(oldTime, "##0.00") + " ms")
		  System.DebugLog("    New array method: " + Format(newTime, "##0.00") + " ms")
		  System.DebugLog("    Performance improvement: " + Format((oldTime / newTime), "##0.00") + "x")

		  TestHelpers.AssertTrue(newTime < oldTime, "Array method faster for large concatenations", totalTests, passedTests, failedTests)
		  TestHelpers.AssertEquals(iterations, oldString.Length, "Old method produces correct result", totalTests, passedTests, failedTests)
		  TestHelpers.AssertEquals(iterations, newString.Length, "New method produces correct result", totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TestNthFieldVsSplit(ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Test NthField vs Split performance

		  System.DebugLog("  Testing NthField vs Split performance...")

		  Dim testString As String = "field1=value1&field2=value2&field3=value3&field4=value4&field5=value5"
		  Const iterations As Integer = 10000

		  // Using NthField in loop (INEFFICIENT)
		  Dim startTime As Double = Microseconds
		  Dim nthFieldResult() As String
		  For i As Integer = 1 To iterations
		    For fieldIndex As Integer = 1 To testString.CountFields("&")
		      Dim field As String = testString.NthField("&", fieldIndex)
		      nthFieldResult.AddRow(field)
		    Next
		  Next
		  Dim nthFieldTime As Double = (Microseconds - startTime) / 1000.0

		  // Using Split (EFFICIENT)
		  startTime = Microseconds
		  Dim splitResult() As String
		  For i As Integer = 1 To iterations
		    Dim fields() As String = testString.Split("&")
		    For Each field As String In fields
		      splitResult.AddRow(field)
		    Next
		  Next
		  Dim splitTime As Double = (Microseconds - startTime) / 1000.0

		  System.DebugLog("    NthField method: " + Format(nthFieldTime, "##0.00") + " ms")
		  System.DebugLog("    Split method: " + Format(splitTime, "##0.00") + " ms")
		  System.DebugLog("    Split is " + Format((nthFieldTime / splitTime), "##0.00") + "x faster")

		  TestHelpers.AssertTrue(splitTime < nthFieldTime, "Split is faster than NthField in loops", totalTests, passedTests, failedTests)

		End Sub
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

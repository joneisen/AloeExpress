#tag Module
Protected Module TestHelpers
	#tag Method, Flags = &h0
		Sub AssertTrue(condition As Boolean, testName As String, ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Assert that a condition is true

		  totalTests = totalTests + 1

		  If condition Then
		    passedTests = passedTests + 1
		    System.DebugLog("  [PASS] " + testName)
		  Else
		    failedTests = failedTests + 1
		    System.DebugLog("  [FAIL] " + testName)
		  End If

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AssertFalse(condition As Boolean, testName As String, ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Assert that a condition is false

		  AssertTrue(Not condition, testName, totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AssertEquals(expected As Variant, actual As Variant, testName As String, ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Assert that two values are equal

		  Dim condition As Boolean = (expected = actual)

		  If Not condition Then
		    System.DebugLog("    Expected: " + expected.StringValue)
		    System.DebugLog("    Actual: " + actual.StringValue)
		  End If

		  AssertTrue(condition, testName, totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AssertNotNil(value As Variant, testName As String, ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Assert that a value is not nil

		  AssertTrue(value <> Nil, testName, totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AssertNil(value As Variant, testName As String, ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Assert that a value is nil

		  AssertTrue(value = Nil, testName, totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MeasureExecutionTime(methodName As String, iterations As Integer) As Double
		  // Measure the execution time of a method
		  // Returns time in milliseconds

		  Dim startTime As Double = Microseconds

		  // Run the test iterations
		  For i As Integer = 1 To iterations
		    // This will be overridden by specific tests
		  Next

		  Dim endTime As Double = Microseconds
		  Dim elapsedMs As Double = (endTime - startTime) / 1000.0

		  System.DebugLog("    Execution time for " + methodName + ": " + Format(elapsedMs, "##0.00") + " ms (" + iterations.ToString + " iterations)")

		  Return elapsedMs

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

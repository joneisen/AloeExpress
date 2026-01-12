#tag Module
Protected Module TestRunner
	#tag Method, Flags = &h0
		Sub RunAllTests()
		  // Comprehensive test suite for AloeExpress
		  // Run all tests and report results

		  Dim totalTests As Integer = 0
		  Dim passedTests As Integer = 0
		  Dim failedTests As Integer = 0

		  System.DebugLog("=" * 80)
		  System.DebugLog("AloeExpress Test Suite - Xojo 2025r3")
		  System.DebugLog("=" * 80)
		  System.DebugLog("")

		  // Memory Leak Tests
		  System.DebugLog(">>> Running Memory Leak Tests...")
		  Call RunMemoryLeakTests(totalTests, passedTests, failedTests)
		  System.DebugLog("")

		  // Performance Tests
		  System.DebugLog(">>> Running Performance Tests...")
		  Call RunPerformanceTests(totalTests, passedTests, failedTests)
		  System.DebugLog("")

		  // API Tests
		  System.DebugLog(">>> Running API Tests...")
		  Call RunAPITests(totalTests, passedTests, failedTests)
		  System.DebugLog("")

		  // WebSocket Tests
		  System.DebugLog(">>> Running WebSocket Tests...")
		  Call RunWebSocketTests(totalTests, passedTests, failedTests)
		  System.DebugLog("")

		  // Session Tests
		  System.DebugLog(">>> Running Session Tests...")
		  Call RunSessionTests(totalTests, passedTests, failedTests)
		  System.DebugLog("")

		  // Cache Tests
		  System.DebugLog(">>> Running Cache Tests...")
		  Call RunCacheTests(totalTests, passedTests, failedTests)
		  System.DebugLog("")

		  // Summary
		  System.DebugLog("=" * 80)
		  System.DebugLog("Test Results Summary")
		  System.DebugLog("=" * 80)
		  System.DebugLog("Total Tests: " + totalTests.ToString)
		  System.DebugLog("Passed: " + passedTests.ToString)
		  System.DebugLog("Failed: " + failedTests.ToString)
		  System.DebugLog("Success Rate: " + Format((passedTests / totalTests) * 100, "##0.00") + "%")
		  System.DebugLog("=" * 80)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunMemoryLeakTests(ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Test for memory leaks in various components

		  TestMemoryLeakTests.TestDatabaseConnectionCleanup(totalTests, passedTests, failedTests)
		  TestMemoryLeakTests.TestTimerCleanup(totalTests, passedTests, failedTests)
		  TestMemoryLeakTests.TestThreadCleanup(totalTests, passedTests, failedTests)
		  TestMemoryLeakTests.TestSocketArrayCleanup(totalTests, passedTests, failedTests)
		  TestMemoryLeakTests.TestWebSocketArrayCleanup(totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunPerformanceTests(ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Test performance of critical operations

		  TestPerformanceTests.TestWebSocketPayloadProcessing(totalTests, passedTests, failedTests)
		  TestPerformanceTests.TestDumpMethodPerformance(totalTests, passedTests, failedTests)
		  TestPerformanceTests.TestStringConcatenationOptimization(totalTests, passedTests, failedTests)
		  TestPerformanceTests.TestNthFieldVsSplit(totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunAPITests(ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Test core API functionality

		  TestAPITests.TestRequestParsing(totalTests, passedTests, failedTests)
		  TestAPITests.TestResponseGeneration(totalTests, passedTests, failedTests)
		  TestAPITests.TestHeaderParsing(totalTests, passedTests, failedTests)
		  TestAPITests.TestCookieParsing(totalTests, passedTests, failedTests)
		  TestAPITests.TestMultipartFormParsing(totalTests, passedTests, failedTests)
		  TestAPITests.TestURLDecoding(totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunWebSocketTests(ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Test WebSocket functionality

		  TestWebSocketTests.TestWebSocketHandshake(totalTests, passedTests, failedTests)
		  TestWebSocketTests.TestWebSocketMessageSend(totalTests, passedTests, failedTests)
		  TestWebSocketTests.TestWebSocketMessageReceive(totalTests, passedTests, failedTests)
		  TestWebSocketTests.TestWebSocketLargePayload(totalTests, passedTests, failedTests)
		  TestWebSocketTests.TestWebSocketConnectionClose(totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunSessionTests(ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Test session management

		  TestSessionTests.TestSessionCreation(totalTests, passedTests, failedTests)
		  TestSessionTests.TestSessionRetrieval(totalTests, passedTests, failedTests)
		  TestSessionTests.TestSessionExpiration(totalTests, passedTests, failedTests)
		  TestSessionTests.TestSessionCleanup(totalTests, passedTests, failedTests)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunCacheTests(ByRef totalTests As Integer, ByRef passedTests As Integer, ByRef failedTests As Integer)
		  // Test caching functionality

		  TestCacheTests.TestCacheSet(totalTests, passedTests, failedTests)
		  TestCacheTests.TestCacheGet(totalTests, passedTests, failedTests)
		  TestCacheTests.TestCacheExpiration(totalTests, passedTests, failedTests)
		  TestCacheTests.TestCacheCleanup(totalTests, passedTests, failedTests)

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

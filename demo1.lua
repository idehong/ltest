--[[
//////////////////////////////////////////////////////////////////////////
// date : 2013-5-4
// auth : macroli(idehong@gmail.com)
// ver  : 0.2
// desc : demo
//////////////////////////////////////////////////////////////////////////    
--]]

------------------------------------------------------------------------------
require("ltest")


local function MyAdd(a, b)
	return  a + b 
end	

local function TestAdd2()
	ltest.ASSERT_EQ(1, MyAdd(2, 8)):print("ltest.ASSERT_EQ(1, MyAdd(2, 8))") 
	ltest.EXCEPT_EQ(2, MyAdd(2, 8)):print("plugin info 2 + 8") 
	ltest.ASSERT_EQ(3, MyAdd(2, 8)):print("plugin info 2 + 8") 
end	

local function TestAdd3()
	ltest.EXCEPT_EQ(10, MyAdd(10, 20))
	ltest.ASSERT_EQ(11, MyAdd(10, 20))
	ltest.ASSERT_EQ(12, MyAdd(10, 20))
end	

local function TestAdd4(a, b)
	ltest.EXCEPT_EQ(a + b, MyAdd(a, b))
	ltest.ASSERT_EQ(a + b, MyAdd(a, b))
end	

function main()
	ltest.InitLTest()

	ltest.AddLTestCase(TestAdd2, "TestAdd2")
	ltest.AddLTestCase(TestAdd3, "TestAdd3")
	ltest.AddLTestCase(TestAdd4, "TestAdd4", {0, 0})
	ltest.AddLTestGroupCase(TestAdd4, "TestAdd4_", { {21, 31}, {22, 32}, {23, 33}, } )

	ltest.RunAllTests()	
end   

main()
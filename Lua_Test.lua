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

local function TestAdd1()
	ltest.ASSERT_EQ(2, MyAdd(1, 1))
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



-- for test case
CMyTestCase1 = ltest.TestCase:new()
function CMyTestCase1:new(oo)
    local o = oo or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function CMyTestCase1.TestEQ(self, v1, v2)
	ltest.ASSERT_EQ(v1, v2)
end

function CMyTestCase1.TestLT(self, v1, v2)
	ltest.ASSERT_LT(v1, v2)
end

function CMyTestCase1.TestLE(self, v1, v2)
	ltest.ASSERT_LE(v1, v2)
end

function CMyTestCase1.TestGT(self, v1, v2)
	ltest.ASSERT_GT(v1, v2)
end

function CMyTestCase1.TestGE(self, v1, v2)
	ltest.ASSERT_GE(v1, v2)
end

function CMyTestCase1.TestNE(self, v1, v2)
	ltest.ASSERT_NE(v1, v2)
end

function CMyTestCase1.TestNEAR(self, v1, v2, nearValue)
	ltest.ASSERT_NEAR(v1, v2, nearValue)
end

function CMyTestCase1.TestTrue(self, v1)
	ltest.ASSERT_TRUE(v1)
end

function CMyTestCase1.TestFalse(self, v1)
	ltest.ASSERT_FALSE(v1)
end



local function MySub(a, b)
	return  a - b 
end	

-- for test case
CMyTestEnv = ltest.TestEnvironment:new()
function CMyTestEnv:new(oo)
    local o = oo or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function CMyTestEnv.SetUp(self)
	print("CMyTestEnv.SetUp")
end

function CMyTestEnv.TearDown(self)
	print("CMyTestEnv.TearDown")
end


-- for test case
CMyTestCase2 = ltest.TestCase:new()
function CMyTestCase2:new(oo)
    local o = oo or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function CMyTestCase2.TestCase21(self)
	ltest.ASSERT_EQ(0, MySub(1, 1))
end

function CMyTestCase2.TestCase22(self)
	ltest.ASSERT_EQ(0, MySub(1, 2))
end

-- for test case
CMyTestCase3 = ltest.TestCase:new()
function CMyTestCase3:new(oo)
    local o = oo or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function CMyTestCase3.SetUpTestCase(self)
	print("CMyTestCase3.SetUpTestCase")
end

function CMyTestCase3.TearDownTestCase(self)
	print("CMyTestCase3.TearDownTestCase")
end


function CMyTestCase3.SetUp(self)
	print("CMyTestCase3.SetUp")
end

function CMyTestCase3.TearDown(self)
	print("CMyTestCase3.TearDown")
end


function CMyTestCase3.Case31(self)
	ltest.ASSERT_EQ(0, MySub(1, 1))
end

function CMyTestCase3.Case32(self)
	ltest.ASSERT_EQ(1, MySub(10, 20))
end

function CMyTestCase3.Case33(self)
	ltest.ASSERT_EQ(0, MySub(2, 2))
end


function main()
	print("-------------------------------- begin")
	local tInitPara = {ltest_filter="CMyTestCase1.*"}
	ltest.InitLTest(tInitPara)

	ltest.AddLTestCase(TestAdd2, "TestAdd2")
	ltest.AddLTestCase(TestAdd1, "TestAdd1")
	ltest.AddLTestCase(TestAdd3, "TestAdd3")
	ltest.AddLTestCase(TestAdd4, "TestAdd4", {0, 0})
	ltest.AddLTestGroupCase(TestAdd4, "TestAdd4_", { {21, 31}, {22, 32}, {23, 33}, } )

	
	ltest.AddLTestSuite(CMyTestCase2:new(), "CMyTestCase2")
	ltest.AddLTestSuite(CMyTestCase3:new(), "CMyTestCase3", "Case")

	local oTmpCls = CMyTestCase1:new()
	local oTmpPara = { {1, 1}, {"ab", "ab"}, {true, true}, {false, false},} 
		--{nil, nil}, {print, print}, 
--		{{}, {}}, {{1, 3}, {1, 3}}, {{a=10, b="BB",},{a=10, b="BB",} },
	--	{{a=10, b="BB", c={4, 5}},{a=10, b="BB", c={4, 5}, } }
	
--	local funTmp = oTmpCls["TestEQ"]	
	ltest.AddLTestGroupCase(oTmpCls["TestEQ"], "TestEQ", oTmpPara, "CMyTestCase1", oTmpCls)
	
	
	ltest.RunAllTests(CMyTestEnv:new())
	
	print("-------------------------------- end")
end   

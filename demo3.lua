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
    o.count = 1
    
    setmetatable(o, self)
    self.__index = self
    return o
end

function CMyTestCase3.SetUpTestCase(self)
    self.count = 1 + self.count
	print("CMyTestCase3.SetUpTestCase")
end

function CMyTestCase3.TearDownTestCase(self)
    self.count = 1 + self.count
	print("CMyTestCase3.TearDownTestCase")
end


function CMyTestCase3.SetUp(self)
    self.count = 1 + self.count
	print("CMyTestCase3.SetUp")
end

function CMyTestCase3.TearDown(self)
    self.count = 1 + self.count

	print("CMyTestCase3.TearDown")
end


function CMyTestCase3.Case31(self)
    self.count = 1 + self.count

	ltest.ASSERT_EQ(0, MySub(1, 1))
end

function CMyTestCase3.Case32(self)
    self.count = 1 + self.count
	ltest.ASSERT_EQ(1, MySub(10, 20))
end

function CMyTestCase3.Case33(self)
    self.count = 1 + self.count
	ltest.ASSERT_EQ(0, MySub(2, 2))
end


function main()
	local tInitPara = {
		ltest_filter = "CMyTestCase2.*:CMyTestCase3.*",
		ltest_list_tests = "ltest_case_list.txt",
		ltest_list_falied = "ltest_case_failed.txt",
	}
	ltest.InitLTest(tInitPara)

	ltest.AddLTestCase(TestAdd1, "TestAdd1")

	
	ltest.AddLTestSuite(CMyTestCase2:new(), "CMyTestCase2")
	ltest.AddLTestSuite(CMyTestCase3:new(), "CMyTestCase3", "Case")

	
	ltest.RunAllTests(CMyTestEnv:new())

	local t = ltest.GetRunStatInfo()
	--print(t.iFailedNum)

end   

main()

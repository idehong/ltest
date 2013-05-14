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


-- for test case
CMyTestCase1 = ltest.TestCase:new()
function CMyTestCase1:new(oo)
    local o = oo or {}
    o.count = 1
    
    setmetatable(o, self)
    self.__index = self
    return o
end

function CMyTestCase1.TestEQ(self, v1, v2)
    self.count = 1 + self.count
	ltest.ASSERT_EQ(v1, v2):print("error seq:" .. self.count)
end

function CMyTestCase1.TestLT(self, v1, v2)
    self.count = 1 + self.count
	ltest.ASSERT_LT(v1, v2):print("error seq:" .. self.count)
end

function CMyTestCase1.TestLE(self, v1, v2)
    self.count = 1 + self.count
	ltest.ASSERT_LE(v1, v2):print("error seq:" .. self.count)
end

function CMyTestCase1.TestGT(self, v1, v2)
    self.count = 1 + self.count
	ltest.ASSERT_GT(v1, v2):print("error seq:" .. self.count)
end

function CMyTestCase1.TestGE(self, v1, v2)
    self.count = 1 + self.count
	ltest.ASSERT_GE(v1, v2):print("error seq:" .. self.count)
end

function CMyTestCase1.TestNE(self, v1, v2)
    self.count = 1 + self.count
	ltest.ASSERT_NE(v1, v2):print("error seq:" .. self.count)
end

function CMyTestCase1.TestNear(self, v1, v2, nearValue)
    self.count = 1 + self.count
	ltest.ASSERT_NEAR(v1, v2, nearValue):print("error seq:" .. self.count)
end

function CMyTestCase1.TestTrue(self, v1)
    self.count = 1 + self.count
	ltest.ASSERT_TRUE(v1):print("error seq:" .. self.count)
end

function CMyTestCase1.TestFalse(self, v1)
    self.count = 1 + self.count
	ltest.ASSERT_FALSE(v1):print("error seq:" .. self.count)
end



function main()
	ltest.InitLTest()

	local oTmpCls = CMyTestCase1:new()
	local oTmpPara = { 
		{1, 1}, {"ab", "ab"}, {true, true}, {false, false}, {nil, nil}, {print, print}, 
		{{}, {}}, {{1, 3}, {1, 3}}, {{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, },{a=10, b="BB", [2] = 2, c={c1=c1, c3=33},}},
		{1, 11}, {"ab", "ab1"}, {true, false}, {false, true}, {nil, 1}, {print, select}, 
		{{1}, {}}, {{1, 3}, {1, 31}}, 
		{{a=10, b="BB", [2] = 2, c={c1="c1", c3=33},}, {a=10, b="BB", [2] = 2, c={c1="c1", c3=32},}},
	}	
	ltest.AddLTestGroupCase(oTmpCls["TestEQ"], "TestEQ_G1_", oTmpPara, "CMyTestCase1", oTmpCls)
	
	local mt = {}
	mt.__lt = function(a, b) return #a < #b end
	mt.__eq = function(a, b) return #a == #b end
	mt.__tostring= function(a) return "element number:" .. #a end
	
	local oTmpPara1 = {1, 2}
	local oTmpPara2 = {1, 2, 3}
	setmetatable(oTmpPara1, mt)
	setmetatable(oTmpPara2, mt)	
	
	local oTmpPara = { {oTmpPara1, oTmpPara2}}
	ltest.AddLTestGroupCase(oTmpCls["TestEQ"], "TestEQ_G2_", oTmpPara, "CMyTestCase1", oTmpCls)
	
	local oTmpPara = { 
		{1, 2}, {"ab", "ab2"}, {true, true}, {false, false}, {nil, nil}, {print, print}, 
		{{}, {4,}}, {{1, 3}, {1, 3, 4}}, {{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=4, },{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=5,}},
		{{}, {}}, {{1, 31}, {1, 31}}, 
		{{a=10, b="BB", [2] = 2, c={c1="c1", c3=33},}, {a=10, b="BB", [2] = 2, c={c1="c1", c3=33},}},
	}	
	ltest.AddLTestGroupCase(oTmpCls["TestLT"], "TestLT_G1_", oTmpPara, "CMyTestCase1", oTmpCls)
	
	local oTmpPara = { 
		{11, 2}, {"ab3", "ab2"}, {true, true}, {false, false}, {nil, nil}, {print, print}, 
		{{5,}, {}}, {{1, 3, 5, 6}, {1, 3, 4}}, {{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=4, },{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=5,}},
		{{}, {}}, {{1, 31}, {1, 31}}, 
		{{a=10, b="BB", [2] = 2, c={c1="c1", c3=35},}, {a=10, b="BB", [2] = 2, c={c1="c1", c3=33},}},
	}	
	ltest.AddLTestGroupCase(oTmpCls["TestGT"], "TestGT_G1_", oTmpPara, "CMyTestCase1", oTmpCls)	


	local oTmpPara = { 
		{1, 2}, {"ab", "ab2"}, {true, true}, {false, false}, {nil, nil}, {print, print}, 
		{{}, {4,}}, {{1, 3}, {1, 3, 4}}, {{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=4, },{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=5,}},
		{{}, {}}, {{1, 31}, {1, 31}}, 
		{{a=10, b="BB", [2] = 2, c={c1="c1", c3=33},}, {a=10, b="BB", [2] = 2, c={c1="c1", c3=33},}},
	}	
	ltest.AddLTestGroupCase(oTmpCls["TestLE"], "TestLE_G1_", oTmpPara, "CMyTestCase1", oTmpCls)

	local oTmpPara = { 
		{1, 2}, {"ab", "ab2"}, {true, true}, {false, false}, {nil, nil}, {print, print}, 
		{{}, {4,}}, {{1, 3}, {1, 3, 4}}, {{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=4, },{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=5,}},
		{{}, {}}, {{1, 31}, {1, 31}}, 
		{{a=10, b="BB", [2] = 2, c={c1="c1", c3=33},}, {a=10, b="BB", [2] = 2, c={c1="c1", c3=33},}},
	}	
	ltest.AddLTestGroupCase(oTmpCls["TestGE"], "TestGE_G1_", oTmpPara, "CMyTestCase1", oTmpCls)


	local oTmpPara = { 
		{1, 2}, {"ab", "ab2"}, {true, true}, {false, false}, {nil, nil}, {print, print}, 
		{{}, {4,}}, {{1, 3}, {1, 3, 4}}, {{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=4, },{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=5,}},
		{{}, {}}, {{1, 31}, {1, 31}}, 
		{{a=10, b="BB", [2] = 2, c={c1="c1", c3=33},}, {a=10, b="BB", [2] = 2, c={c1="c1", c3=33},}},
	}	
	ltest.AddLTestGroupCase(oTmpCls["TestNE"], "TestNE_G1_", oTmpPara, "CMyTestCase1", oTmpCls)


	local oTmpPara = { 
		{1}, {"ab"}, {true}, {false}, {nil}, {print}, 
		{{}, }, {{1, 3}}, {{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=4, }},		
	}	
	ltest.AddLTestGroupCase(oTmpCls["TestTrue"], "TestTrue_G1_", oTmpPara, "CMyTestCase1", oTmpCls)

	local oTmpPara = { 
		{1}, {"ab"}, {true}, {false}, {nil}, {print}, 
		{{}, }, {{1, 3}}, {{a=10, b="BB", [2] = 2, c={c1=c1, c3=33}, d=4, }},		
	}	
	ltest.AddLTestGroupCase(oTmpCls["TestFalse"], "TestFalse_G1_", oTmpPara, "CMyTestCase1", oTmpCls)
	

	local oTmpPara = { 
		{1, 2, 0.001}, {"ab", "ab2", 0.001}, {true, true, 0.001}, {false, false, 0.001}, {nil, nil, 0.001}, {print, print, 0.001}, 
		{1.0011, 1.0012, 0.001}, {1.0013, 1.0012, 0.001}, 
	}	
	ltest.AddLTestGroupCase(oTmpCls["TestNear"], "TestNear_G1_", oTmpPara, "CMyTestCase1", oTmpCls)
	
	ltest.RunAllTests()
end   

main()
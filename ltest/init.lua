--[[
//////////////////////////////////////////////////////////////////////////
// date ：2013-3-21
// auth : macroli(idehong@gmail.com)
// ver  : 1.05
// desc : 常用工具类函数
//////////////////////////////////////////////////////////////////////////    
--]]
------------------------------------------------------------------------------

module(..., package.seeall)

VERSION = "0.1"

-- for test environment
TestEnvironment = {}
function TestEnvironment:new(oo)
    local o = oo or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TestEnvironment.privateName(self)
	return "env_macro"	
end

function TestEnvironment.SetUp(self)	
end

function TestEnvironment.TearDown(self)	
end


-- for test case
TestCase = {}
function TestCase:new(oo)
    local o = oo or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TestCase.privateName(self)
	return "case_macro"	
end

function TestCase.SetUpTestCase(self)	
end

function TestCase.TearDownTestCase(self)	
end

function TestCase.SetUp(self)	
end

function TestCase.TearDown(self)	
end


-- for assert
require("ltest.lassert")
local _atErrLv = 6
local _atMgr = ltest.lassert.CAssertMgr:new()
function ASSERT_EQ(v1, v2)
	_atMgr:AssertEQ(v1, v2); _atMgr:PCallCheckResult(_atErrLv, "ASSERT_EQ failed", v1, v2); return _atMgr
end

function ASSERT_LT(v1, v2)
	_atMgr:AssertLT(v1, v2); _atMgr:PCallCheckResult(_atErrLv, "ASSERT_LT failed", v1, v2); return _atMgr
end

function ASSERT_LE(v1, v2)
	_atMgr:AssertLE(v1, v2); _atMgr:PCallCheckResult(_atErrLv, "ASSERT_LE failed", v1, v2); return _atMgr
end

function ASSERT_GT(v1, v2)
	_atMgr:AssertGT(v1, v2); _atMgr:PCallCheckResult(_atErrLv, "ASSERT_GT failed", v1, v2); return _atMgr
end

function ASSERT_GE(v1, v2)
	_atMgr:AssertGE(v1, v2); _atMgr:PCallCheckResult(_atErrLv, "ASSERT_GE failed", v1, v2); return _atMgr
end

function ASSERT_NE(v1, v2)
	_atMgr:AssertNE(v1, v2); _atMgr:PCallCheckResult(_atErrLv, "ASSERT_NE failed", v1, v2); return _atMgr
end

function ASSERT_NEAR(v1, v2, nearValue)
	_atMgr:AssertNear(v1, v2, nearValue); _atMgr:PCallCheckResult(_atErrLv, "ASSERT_NEAR failed", v1, v2); return _atMgr
end

function ASSERT_TRUE(v1)
	_atMgr:AssertTrue(v1); _atMgr:PCallCheckResult1(_atErrLv, "ASSERT_TRUE failed", v1); return _atMgr
end

function ASSERT_FALSE(v1)
	_atMgr:AssertFalse(v1); _atMgr:PCallCheckResult1(_atErrLv, "ASSERT_FALSE failed", v1); return _atMgr
end


-- for test output
TestOutPut = {}
function TestOutPut:new(oo)
    local o = oo or {}
    o.output = {
    	labelNum = 10,
    	fmt = { left = "[%-10s]", right = "[%10s]", },
    	label = { run = {label=" RUN", fmt="left",}, ok = {label="OK ",  fmt="right",}, failed = {label="  FAILED",  fmt="left",},
    		passed = {label="  PASSED", fmt="left",},
    		split = {label="----------", fmt="right",},  
    		group = {label="==========", fmt="right",},
    	},
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

-- output tip: exec success
function TestOutPut.Ok(self, ...)
	print(...)
end

-- output tip: exec failed
function TestOutPut.Failed(self, ...)
	print(...)
end

-- output tip: tip msg
function TestOutPut.Message(self, ...)
	print(...)
end

function TestOutPut.Text(self, ...)
	print(...)
end

function TestOutPut.GetFMTStr(self, label)
	local tObj = self.output.label[label]
	if not tObj then return end	
	return string.format(self.output.fmt[tObj.fmt], tObj.label)	
end


-- for test mgr
local TestMgr = {}
function TestMgr:new(oo)
    local o = {
    	data = {
	    	oOut = false, generalGlobalName="global",	    	
	    	generalSuiteNo=2, 
	    	global={ prop={name="global", generalNo=1,bSys=true, oCls=false, no=1, costTime=0, totalNum=0, okNum=0, failedNum=0,}, list={}},

			-- key for name, value = {prop={}, list={}}
	    	all_suite = {}, 
	    	notcase = {privateName=true, SetUpTestCase=true, TearDownTestCase=true, SetUp=true, TearDown=true, TestCase=true},
    	},
    }
    
    setmetatable(o, self)
    self.__index = self
    return o
end

function TestMgr.Init(self, tPara, oOutput)	
	if oOutput then 
		self.data.oOutput = oOutput
	else
		self.data.oOutput = TestOutPut:new()
	end
	self.data.all_suite[self.data.generalGlobalName] = self.data.global
end

function TestMgr.Fini(self)	
	self.data.all_suite = {}
	self.data.generalSuiteNo = 2
	self.data.global={ prop={name="global", generalNo=1,bSys=true, oCls=false, no=1, costTime=0, totalNum=0, okNum=0, failedNum=0,}, list={}}
end

function TestMgr.AddSuite(self, strSuiteName, oCls, filterCaseName)	
	if not oCls or "case_macro" ~= oCls:privateName() or self.data.notcase[strSuiteName] then return false end
	local strFind = "Test"
	if filterCaseName and type(filterCaseName) == "string" then strFind = filterCaseName end
		
	local tSuite = self:addRealSuite(strSuiteName, oCls)
	if not tSuite then return false end
	
	local tCaseKey = {}
	for k, v in pairs(oCls) do
		if type(k) == "string" and "__" ~= string.sub(k, 1, 2) and type(v) == "function" and string.find(k, strFind) and not self.data.notcase[k] then
			table.insert(tCaseKey, k)
		end
	end
	for k, v in pairs(oCls.__index) do
		if type(k) == "string" and "__" ~= string.sub(k, 1, 2) and type(v) == "function" and string.find(k, strFind) and not self.data.notcase[k] then
			table.insert(tCaseKey, k)
		end
	end
	
	table.sort(tCaseKey)
	for k, v in pairs(tCaseKey) do
		self:addRealCase(tSuite, v, oCls[v], nil)
	end
	
	return true
end

function TestMgr.AddCase(self, strCaseName, oFun, tPara, strSuiteName, oCls)
	if type(oFun) ~= "function" or type(strCaseName) ~= type("") then return false end	
	
	local tSuite  = false
	if strSuiteName then 
		tSuite = self:addRealSuite(strSuiteName, oCls)
	else
		tSuite = self:addRealSuite(self.data.generalGlobalName, oCls)	
	end
	
	if tSuite then return self:addRealCase(tSuite, strCaseName, oFun, tPara) else return false	end
end

function TestMgr.Run(self, oEnv)
	local oOutput = self.data.oOutput
	-- todo
	oOutput:Message("Note: ltest filter = CDailyBattleTest.*\r\n")
	local iCount, iGroup = self:countAllCase()
	local strBegin = string.format("%s Running %d tests from %d test case.", oOutput:GetFMTStr("group"), iCount, iGroup)
	oOutput:Message( strBegin )
	
	local bUseEnv = (oEnv and "env_macro" == oEnv:privateName())
	if bUseEnv then	
		oEnv:SetUp() 
		oOutput:Message( oOutput:GetFMTStr("split") .. " Global test environment set-up.")
	end

	local tFailedList = self:runAllSuite(oOutput)
	
	if bUseEnv then	
		oEnv:TearDown()	
		oOutput:Message( oOutput:GetFMTStr("split") .. " Global test environment tear-down.")
	end	
	
	local iTotalTime, iPassedNum = 0, 0
	for k, v in pairs(self.data.all_suite) do
		iTotalTime = iTotalTime + v.prop.costTime
		iPassedNum = iPassedNum + v.prop.okNum
	end
	oOutput:Message( string.format("%s (%d ms total)", strBegin, iTotalTime) )
	oOutput:Message( string.format( "%s %d tests.", oOutput:GetFMTStr("passed"), iPassedNum) )
	
	local iFailedNum = #tFailedList
	if iFailedNum > 0 then
		local strTipFailed = oOutput:GetFMTStr("failed")
		oOutput:Message( string.format( "%s %d tests, listed below:", strTipFailed, iFailedNum) )
		for k, v in pairs(tFailedList) do
			oOutput:Message( string.format( "%s %s", strTipFailed, v) )
		end
		oOutput:Message( string.format( "\r\n%d FAILED TESTS", iFailedNum) )
	end
	
	self:Fini()
end

function TestMgr.countAllCase(self, oOutput)	
	local iCount, iGroup = 0, 0
	for k, v in pairs(self.data.all_suite) do
		iCount = iCount + v.prop.totalNum
		iGroup = iGroup + 1
	end
	return iCount, iGroup
end	

function TestMgr.runAllSuite(self, oOutput)	
	local tSuiteKey = {}	
	for k, v in pairs(self.data.all_suite) do
		tSuiteKey[v.prop.no] = { name=k, no=v.prop.no }
	end

	local tFailedList = {}		
	for k, v in ipairs(tSuiteKey) do
		self:runGroupSuite(tFailedList, self.data.all_suite[v.name], oOutput)
	end
	return tFailedList
end

function TestMgr.runGroupSuite(self, tFailedList, tSuite, oOutput)
	local tCaseKey = {}
	for k, v in pairs(tSuite.list) do
		tCaseKey[v.no] = {name=k, no=v.no}
	end
	
	local strTipBegin = string.format("%s %d tests from %s", oOutput:GetFMTStr("split"), #tCaseKey, tSuite.prop.name)
	oOutput:Message( strTipBegin )	
	if tSuite.prop.oCls then tSuite.prop.oCls:SetUpTestCase() end
	
	local iItemTime, strItemTxt, oTmpCase = 0, "", false
	local bResult, strError = false, ""
	for k, v in ipairs(tCaseKey) do
		oTmpCase = tSuite.list[v.name]
		oOutput:Text(oOutput:GetFMTStr("run") .. " " .. oTmpCase.label)
		iItemTime = os.clock()
		if tSuite.prop.oCls then tSuite.prop.oCls:SetUp() end
		
		if oTmpCase.para then
			if oTmpCase.para[1] then
				bResult, strError = pcall(function () oTmpCase.fun( unpack( oTmpCase.para) ) end)
			else
				bResult, strError = pcall(function () oTmpCase.fun( oTmpCase.para) end)
			end
		else
			bResult, strError = pcall(function () oTmpCase.fun() end)		
		end
		oTmpCase.costTime = os.clock() - iItemTime
		tSuite.prop.costTime = oTmpCase.costTime + tSuite.prop.costTime
		strItemTxt = string.format(" %s (%d ms)", oTmpCase.label, iItemTime)
		if not bResult or not _atMgr:GetResult() then 
			oTmpCase.result = false
			table.insert(tFailedList, oTmpCase.label)
			tSuite.prop.failedNum = 1 + tSuite.prop.failedNum
			if strError then oOutput:Failed(strError) end
	
			if tSuite.prop.oCls then tSuite.prop.oCls:TearDown() end		
			oOutput:Text(oOutput:GetFMTStr("failed") .. strItemTxt )
		else
			oTmpCase.result = true
			tSuite.prop.okNum = 1 + tSuite.prop.okNum
	
			if tSuite.prop.oCls then tSuite.prop.oCls:TearDown() end		
			oOutput:Text(oOutput:GetFMTStr("ok") .. strItemTxt)
		end
	end		

	if tSuite.prop.oCls then tSuite.prop.oCls:TearDownTestCase() end
	local strTipEnd = string.format("%s (%d ms total)\r\n", strTipBegin, tSuite.prop.costTime)
	oOutput:Message( strTipEnd )
end

function TestMgr.addRealSuite(self, strSuiteName, cCls)	
	if oCls and (type(oCls) ~= type({}) or type(oCls.privateName) ~= type(print) or "case_macro" ~= oCls:privateName()) then return end
	if not strSuiteName or type(strSuiteName) ~= type("") or self.data.notcase[strSuiteName] then return end	

	local tSuiteGroup = self.data.all_suite
	if not tSuiteGroup[strSuiteName] then  
		tSuiteGroup[strSuiteName] = {prop={name=strSuiteName, generalNo=1, bSys=false, oCls=cCls, no=self.data.generalSuiteNo, costTime=0, totalNum=0, okNum=0, failedNum=0,}, list={}} 
		self.data.generalSuiteNo = 1 + self.data.generalSuiteNo
	end
	return tSuiteGroup[strSuiteName] 
end
	
function TestMgr.addRealCase(self, tSuite, strCaseName, oFun, tPara)
	if strCaseName and self.data.notcase[strCaseName] then return false end
	
	local tSuiteProp = tSuite.prop
	local tCurrSuite = tSuite.list
	
	if tCurrSuite[strCaseName] then  return false end
	local strLabel = strCaseName
	if not tSuiteProp.bSys then strLabel = tSuiteProp.name .. "." .. strCaseName end
	tCurrSuite[strCaseName] = {fun=oFun, para=tPara, label=strLabel, result=true, costTime=0, no=tSuiteProp.generalNo,}
	tSuiteProp.generalNo = 1 + tSuiteProp.generalNo
	tSuiteProp.totalNum = 1 + tSuiteProp.totalNum
	return true
end

-- for init help function
local _oTestMgr = false
function InitLTest(tPara)
	if not _oTestMgr then _oTestMgr = TestMgr:new() else _oTestMgr:Fini() end
	_oTestMgr:Init(tPara)
	return _oTestMgr
end

-- return true if add success
function AddLTestSuite(oCls, strSuiteName, filterCaseName)
	if not _oTestMgr then return false end
	return _oTestMgr:AddSuite(strSuiteName, oCls, filterCaseName)
end

function AddLTestCase(oFun, strCaseName, tPara, labelNamePrefix, oCls)
	if not _oTestMgr then return false end
	return _oTestMgr:AddCase(strCaseName, oFun, tPara, labelNamePrefix, oCls)
end

function AddLTestGroupCase(oFun, strCaseName, tGroupPara, labelNamePrefix, oCls)
	if not _oTestMgr then return false end
	for i, v in ipairs(tGroupPara) do
		_oTestMgr:AddCase(strCaseName .. "/" .. i, oFun, v, labelNamePrefix, oCls)
	end
end

-- run all test case, return 0 if success
function RunAllTests(oEnv)
	if not _oTestMgr then return false end
	return _oTestMgr:Run(oEnv)
end



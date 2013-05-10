--[[
//////////////////////////////////////////////////////////////////////////
// date : 2013-5-4
// auth : macroli(idehong@gmail.com)
// ver  : 0.3
// desc : output 
//////////////////////////////////////////////////////////////////////////    
--]]
------------------------------------------------------------------------------

module(..., package.seeall)

-- for test output
local TestOutPutBase = {}
function TestOutPutBase:new(oo)
    local o = oo or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TestOutPutBase.FilterInfo(self, ...)
end

function TestOutPutBase.BeginCase(self, strLabelName)
end

function TestOutPutBase.EndCase(self, bRun, bSuccess, iTime, strLabelName)
end

function TestOutPutBase.BeginSuite(self, iNumber, strSuiteName)
end

function TestOutPutBase.EndSuite(self, iNumber, strSuiteName, iTime, iFailedNum)
end

function TestOutPutBase.BeginGroupSuite(self, iCaseNum, iSuiteNum)
end

function TestOutPutBase.EndGroupSuite(self, iCaseNum, iSuiteNum, iTime, iFailedNum, iStartTime)
end

function TestOutPutBase.BeginGroupEnv(self, strTip)
end

function TestOutPutBase.EndGroupEnv(self, strTip)
end

function TestOutPutBase.FailedTxt(self, ...)
end

function TestOutPutBase.StaticInfo(self)
end

function TestOutPutBase.Message(self, ...)
	print( self:mergerTxt(...) )
end

function TestOutPutBase.mergerTxt(self, ...)
	return string.format(...) 
end


-- for test output
CmdTestOutPut = TestOutPutBase:new()
function CmdTestOutPut:new(oo)
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
    o.stat = {
    	iTotalCase = 0, iTotalSuite = 0, iTotalPassed = 0,
    	tFailedName = {},  
    	iCurrCaseCount = 0,  	
    }
    
    setmetatable(o, self)
    self.__index = self
    return o
end

function CmdTestOutPut.FilterInfo(self, ...)
	self:Message(...)
end

function CmdTestOutPut.BeginCase(self, strLabelName)
	self.stat.iCurrCaseCount = 1 + self.stat.iCurrCaseCount
	self:Message("%s %s", self:getFMTStr("run", string.format(" %d%%", math.floor(self.stat.iCurrCaseCount*100/self.stat.iTotalCase))), strLabelName)
end

function CmdTestOutPut.EndCase(self, bRun, bSuccess, iTime, strLabelName)
	if not bRun then return end

	if bSuccess then
		self.stat.iTotalPassed = 1 + self.stat.iTotalPassed
		self:Message("%s %s (%d ms)", self:getFMTStr("ok"), strLabelName, iTime)
	else
		table.insert(self.stat.tFailedName, strLabelName)
		self:Message("%s %s (%d ms)", self:getFMTStr("failed"), strLabelName, iTime)
	end
end

function CmdTestOutPut.BeginSuite(self, iNumber, strSuiteName)
	self:Message("%s %d tests from %s.", self:getFMTStr("split"), iNumber, strSuiteName)
end

function CmdTestOutPut.EndSuite(self, iNumber, strSuiteName, iTime, iFailedNum)
	self:Message("%s %d tests from %s (%d ms total).\n", self:getFMTStr("split"), iNumber, strSuiteName, iTime)
end

function CmdTestOutPut.BeginGroupSuite(self, iCaseNum, iSuiteNum)
	self.stat.iTotalCase  = iCaseNum
	self.stat.iTotalSuite = iSuiteNum
	
	self:Message("%s Running %d tests from %d test cases", self:getFMTStr("group"), iCaseNum, iSuiteNum)
end

function CmdTestOutPut.EndGroupSuite(self, iTime)
	self:Message("%s Running %d  tests from %d test cases ran. (%d ms total)", self:getFMTStr("group"), self.stat.iTotalCase, self.stat.iTotalSuite, iTime)
end

function CmdTestOutPut.BeginGroupEnv(self)
	self:Message("%s Global test environment set-up.", self:getFMTStr("split"))	
end

function CmdTestOutPut.EndGroupEnv(self)
	self:Message("%s Global test environment tear-down.", self:getFMTStr("split"))
end

function CmdTestOutPut.FailedTxt(self, ...)
end

function CmdTestOutPut.StaticInfo(self)
	self:Message("%s %d tests.", self:getFMTStr("passed"), self.stat.iTotalPassed)

	local iFailedNum = #self.stat.tFailedName
	if iFailedNum <= 0 then return end
	self:Message("%s %d tests, listed below:", self:getFMTStr("failed"), iFailedNum)
	for k, v in pairs(self.stat.tFailedName) do
		self:Message("%s %s", self:getFMTStr("failed"), v)
	end
	
	self:Message("\n %d TESTS, %d FAILED", self.stat.iTotalCase, iFailedNum)

end

function CmdTestOutPut.getFMTStr(self, label, addvalue)
	local tObj = self.output.label[label]
	if addvalue then
		return string.format(self.output.fmt[tObj.fmt], tObj.label .. addvalue)	
	else
		return string.format(self.output.fmt[tObj.fmt], tObj.label)	
	end
end

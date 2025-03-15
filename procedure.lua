--Fusion check functions
Auxiliary.FCheckAdditional=nil
Auxiliary.FGoalCheckAdditional=nil

--Ritual check functions
Auxiliary.RCheckAdditional=nil
Auxiliary.RGCheckAdditional=nil

--Gemini Summon
function Auxiliary.IsDualState(effect)
	local c=effect:GetHandler()
	return not c:IsDisabled() and c:IsDualState()
end
function Auxiliary.IsNotDualState(effect)
	local c=effect:GetHandler()
	return c:IsDisabled() or not c:IsDualState()
end
function Auxiliary.DualNormalCondition(effect)
	local c=effect:GetHandler()
	return c:IsFaceup() and not c:IsDualState()
end
function Auxiliary.EnableDualAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCondition(Auxiliary.DualNormalCondition)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
end

--Synchro Summon
function Auxiliary.Tuner(f,...)
	local ext_params={...}
	return	function(target,syncard)
				return target:IsTuner(syncard) and (not f or f(target,table.unpack(ext_params)))
			end
end
function Auxiliary.NonTuner(f,...)
	local ext_params={...}
	return	function(target,syncard)
				return target:IsNotTuner(syncard) and (not f or f(target,table.unpack(ext_params)))
			end
end
---Synchro monster, 1 tuner + min to max monsters
---@param c Card
---@param f1 function|nil
---@param f2 function|nil
---@param minc integer
---@param maxc? integer
function Auxiliary.AddSynchroProcedure(c,f1,f2,minc,maxc)
	if maxc==nil then maxc=99 end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynCondition(f1,f2,minc,maxc))
	e1:SetTarget(Auxiliary.SynTarget(f1,f2,minc,maxc))
	e1:SetOperation(Auxiliary.SynOperation(f1,f2,minc,maxc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function Auxiliary.SynCondition(f1,f2,minct,maxct)
	return	function(e,c,smat,mg,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				if smat and smat:IsTuner(c) and (not f1 or f1(smat)) then
					return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
				return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg)
			end
end
function Auxiliary.SynTarget(f1,f2,minct,maxct)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local g=nil
				if smat and smat:IsTuner(c) and (not f1 or f1(smat)) then
					g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,mg)
				else
					g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc,smat,mg)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.SynOperation(f1,f2,minct,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
--Synchro monster, 1 tuner + 1 monster
--backward compatibility
function Auxiliary.AddSynchroProcedure2(c,f1,f2)
	Auxiliary.AddSynchroProcedure(c,f1,f2,1,1)
end
---Synchro monster, f1~f3 each 1 MONSTER + f4 min to max monsters
---@param c Card
---@param f1 function|nil
---@param f2 function|nil
---@param f3 function|nil
---@param f4 function|nil
---@param minc integer
---@param maxc integer
---@param gc? function
function Auxiliary.AddSynchroMixProcedure(c,f1,f2,f3,f4,minc,maxc,gc)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetTarget(Auxiliary.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetOperation(Auxiliary.SynMixOperation(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function Auxiliary.SynMaterialFilter(c,syncard)
	return c:IsFaceupEx() and c:IsCanBeSynchroMaterial(syncard)
end
function Auxiliary.SynLimitFilter(c,f,e,syncard)
	return f and not f(e,c,syncard)
end
function Auxiliary.GetSynchroLevelFlowerCardian(c)
	return 2
end
function Auxiliary.GetSynMaterials(tp,syncard)
	local mg=Duel.GetSynchroMaterial(tp):Filter(Auxiliary.SynMaterialFilter,nil,syncard)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	return mg
end
function Auxiliary.SynMixCondition(f1,f2,f3,f4,minct,maxct,gc)
	return	function(e,c,smat,mg1,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minct
				local maxc=maxct
				if min then
					local exct=0
					if f2 then exct=exct+1 end
					if f3 then exct=exct+1 end
					if min-exct>minc then minc=min-exct end
					if max-exct<maxc then maxc=max-exct end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				if Duel.IsPlayerAffectedByEffect(tp,8173184) then
					Duel.RegisterFlagEffect(tp,8173184+1,0,0,1)
				end
				if smat and not smat:IsCanBeSynchroMaterial(c) then
					Duel.ResetFlagEffect(tp,8173184+1)
					return false
				end
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
					mgchk=true
				else
					mg=Auxiliary.GetSynMaterials(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				local res=mg:IsExists(Auxiliary.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk)
				Duel.ResetFlagEffect(tp,8173184+1)
				return res
			end
end
function Auxiliary.SynMixTarget(f1,f2,f3,f4,minct,maxct,gc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				local minc=minct
				local maxc=maxct
				if min then
					local exct=0
					if f2 then exct=exct+1 end
					if f3 then exct=exct+1 end
					if min-exct>minc then minc=min-exct end
					if max-exct<maxc then maxc=max-exct end
					if minc>maxc then return false end
				end
				::SynMixTargetSelectStart::
				if Duel.IsPlayerAffectedByEffect(tp,8173184) then
					Duel.RegisterFlagEffect(tp,8173184+1,0,0,1)
				end
				local g=Group.CreateGroup()
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
					mgchk=true
				else
					mg=Auxiliary.GetSynMaterials(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				local c1
				local c2
				local c3
				local g4=Group.CreateGroup()
				local cancel=Duel.IsSummonCancelable()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				c1=mg:Filter(Auxiliary.SynMixFilter1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
				if not c1 then goto SynMixTargetSelectCancel end
				g:AddCard(c1)
				if f2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					c2=mg:Filter(Auxiliary.SynMixFilter2,g,f2,f3,f4,minc,maxc,c,mg,smat,c1,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
					if not c2 then goto SynMixTargetSelectCancel end
					if g:IsContains(c2) then goto SynMixTargetSelectStart end
					g:AddCard(c2)
					if f3 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
						c3=mg:Filter(Auxiliary.SynMixFilter3,g,f3,f4,minc,maxc,c,mg,smat,c1,c2,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
						if not c3 then goto SynMixTargetSelectCancel end
						if g:IsContains(c3) then goto SynMixTargetSelectStart end
						g:AddCard(c3)
					end
				end
				for i=0,maxc-1 do
					local mg2=mg:Clone()
					if f4 then
						mg2=mg2:Filter(f4,g,c,c1,c2,c3)
					else
						mg2:Sub(g)
					end
					local cg=mg2:Filter(Auxiliary.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,gc,mgchk)
					if cg:GetCount()==0 then break end
					local finish=Auxiliary.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,gc,mgchk)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local c4=cg:SelectUnselect(g+g4,tp,finish,cancel,minc,maxc)
					if not c4 then
						if finish then break
						else goto SynMixTargetSelectCancel end
					end
					if g:IsContains(c4) or g4:IsContains(c4) then goto SynMixTargetSelectStart end
					g4:AddCard(c4)
				end
				g:Merge(g4)
				if g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					Duel.ResetFlagEffect(tp,8173184+1)
					return true
				end
				::SynMixTargetSelectCancel::
				Duel.ResetFlagEffect(tp,8173184+1)
				return false
			end
end
function Auxiliary.SynMixOperation(f1,f2,f3,f4,minct,maxct,gc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
function Auxiliary.SynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat,gc,mgchk)
	return (not f1 or f1(c,syncard)) and mg:IsExists(Auxiliary.SynMixFilter2,1,c,f2,f3,f4,minc,maxc,syncard,mg,smat,c,gc,mgchk)
end
function Auxiliary.SynMixFilter2(c,f2,f3,f4,minc,maxc,syncard,mg,smat,c1,gc,mgchk)
	if f2 then
		return f2(c,syncard,c1)
			and (mg:IsExists(Auxiliary.SynMixFilter3,1,Group.FromCards(c1,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c,gc,mgchk)
				or minc==0 and Auxiliary.SynMixFilter4(c,nil,1,1,syncard,mg,smat,c1,nil,nil,gc,mgchk))
	else
		return mg:IsExists(Auxiliary.SynMixFilter4,1,c1,f4,minc,maxc,syncard,mg,smat,c1,nil,nil,gc,mgchk)
	end
end
function Auxiliary.SynMixFilter3(c,f3,f4,minc,maxc,syncard,mg,smat,c1,c2,gc,mgchk)
	if f3 then
		return f3(c,syncard,c1,c2)
			and (mg:IsExists(Auxiliary.SynMixFilter4,1,Group.FromCards(c1,c2,c),f4,minc,maxc,syncard,mg,smat,c1,c2,c,gc,mgchk)
				or minc==0 and Auxiliary.SynMixFilter4(c,nil,1,1,syncard,mg,smat,c1,c2,nil,gc,mgchk))
	else
		return mg:IsExists(Auxiliary.SynMixFilter4,1,Group.FromCards(c1,c2),f4,minc,maxc,syncard,mg,smat,c1,c2,nil,gc,mgchk)
	end
end
function Auxiliary.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,sg,syncard,c1,c2,c3)
	else
		mg:Sub(sg)
	end
	return Auxiliary.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc,mgchk)
end
function Auxiliary.SynMixCheck(mg,sg1,minc,maxc,syncard,smat,gc,mgchk)
	local tp=syncard:GetControler()
	local sg=Group.CreateGroup()
	if minc<=0 and Auxiliary.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat,gc,mgchk) then return true end
	if maxc==0 then return false end
	return mg:IsExists(Auxiliary.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat,gc,mgchk)
end
function Auxiliary.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk)
	sg:AddCard(c)
	ct=ct+1
	local res=Auxiliary.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
		or (ct<maxc and mg:IsExists(Auxiliary.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
-- the material is in hand and don't has extra synchro material effect itself
-- that mean some other tuner added it as material
function Auxiliary.SynMixHandFilter(c,tp,syncard)
	if not c:IsLocation(LOCATION_HAND) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_SYNCHRO_MATERIAL,tp)}
	for _,te in pairs(le) do
		local tf=te:GetValue()
		if Auxiliary.GetValueType(tf)=="function" then
			if tf(te,syncard) then return false end
		else
			if tf~=0 then return false end
		end
	end
	return true
end
function Auxiliary.SynMixHandCheck(g,tp,syncard)
	local hg=g:Filter(Auxiliary.SynMixHandFilter,nil,tp,syncard)
	local hct=hg:GetCount()
	if hct>0 then
		local found=false
		for c in Auxiliary.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(Auxiliary.SynLimitFilter,1,c,hf,he,syncard) then return false end
				if (hmin and hct<hmin) or (hmax and hct>hmax) then return false end
			end
		end
		if not found then return false end
	end
	return true
end
function Auxiliary.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if gc and not gc(g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not Auxiliary.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	if Duel.IsPlayerAffectedByEffect(tp,8173184)
		and not g:IsExists(Auxiliary.Tuner(Card.IsSetCard,0x2),1,nil,syncard) then return false end
	if not g:CheckWithSumEqual(Card.GetSynchroLevel,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard)
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(Auxiliary.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
		then return false end
	if not (mgchk or Auxiliary.SynMixHandCheck(g,tp,syncard)) then return false end
	for c in Auxiliary.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(Auxiliary.SynLimitFilter,1,c,lf,le,syncard) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end
--Checking Tune Magician
function Auxiliary.TuneMagicianFilter(c,e)
	local f=e:GetValue()
	return f(e,c)
end
function Auxiliary.TuneMagicianCheckX(c,sg,ecode)
	local eset={c:IsHasEffect(ecode)}
	for _,te in pairs(eset) do
		if sg:IsExists(Auxiliary.TuneMagicianFilter,1,c,te) then return true end
	end
	return false
end
function Auxiliary.TuneMagicianCheckAdditionalX(ecode)
	return	function(g)
				return not g:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,g,ecode)
			end
end

--Xyz Summon
function Auxiliary.XyzAlterFilter(c,alterf,xyzc,e,tp,alterop)
	return alterf(c,e,tp,xyzc) and c:IsCanBeXyzMaterial(xyzc) and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0
		and not c:IsHasEffect(EFFECT_XYZ_MIN_COUNT)
		and Auxiliary.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and (not alterop or alterop(e,tp,0,c))
end
---Xyz monster, lv k*n
---@param c Card
---@param f function|nil
---@param lv integer
---@param ct integer
---@param alterf? function
---@param alterdesc? string
---@param maxct? integer
---@param alterop? function
function Auxiliary.AddXyzProcedure(c,f,lv,ct,alterf,alterdesc,maxct,alterop)
	if not maxct then maxct=ct end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if alterf then
		e1:SetCondition(Auxiliary.XyzConditionAlter(f,lv,ct,maxct,alterf,alterdesc,alterop))
		e1:SetTarget(Auxiliary.XyzTargetAlter(f,lv,ct,maxct,alterf,alterdesc,alterop))
		e1:SetOperation(Auxiliary.XyzOperationAlter(f,lv,ct,maxct,alterf,alterdesc,alterop))
	else
		e1:SetCondition(Auxiliary.XyzCondition(f,lv,ct,maxct))
		e1:SetTarget(Auxiliary.XyzTarget(f,lv,ct,maxct))
		e1:SetOperation(Auxiliary.XyzOperation(f,lv,ct,maxct))
	end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
--Xyz Summon(normal)
function Auxiliary.XyzCondition(f,lv,minct,maxct)
	--og: use special material
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function Auxiliary.XyzTarget(f,lv,minct,maxct)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzOperation(f,lv,minct,maxct)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					local sg=Group.CreateGroup()
					local tc=mg:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=mg:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--Xyz summon(alterf)
function Auxiliary.XyzConditionAlter(f,lv,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				if (not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,alterop) then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function Auxiliary.XyzTargetAlter(f,lv,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,alterop)
				local b1=Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				local b2=(not min or min<=1) and #altg>0
				local g=nil
				local cancel=Duel.IsSummonCancelable()
				if b2 and (not b1 or Duel.SelectYesNo(tp,alterdesc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local tc=altg:SelectUnselect(nil,tp,false,cancel,1,1)
					if tc then
						g=Group.FromCards(tc)
						if alterop then alterop(e,tp,1,tc) end
					end
				else
					e:SetLabel(0)
					g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzOperationAlter(f,lv,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
---Xyz monster, any condition
---@param c Card
---@param f function|nil
---@param gf function|nil
---@param minc integer
---@param maxc integer
---@param alterf? function
---@param alterdesc? string
---@param alterop? function
function Auxiliary.AddXyzProcedureLevelFree(c,f,gf,minc,maxc,alterf,alterdesc,alterop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if alterf then
		e1:SetCondition(Auxiliary.XyzLevelFreeConditionAlter(f,gf,minc,maxc,alterf,alterdesc,alterop))
		e1:SetTarget(Auxiliary.XyzLevelFreeTargetAlter(f,gf,minc,maxc,alterf,alterdesc,alterop))
		e1:SetOperation(Auxiliary.XyzLevelFreeOperationAlter(f,gf,minc,maxc,alterf,alterdesc,alterop))
	else
		e1:SetCondition(Auxiliary.XyzLevelFreeCondition(f,gf,minc,maxc))
		e1:SetTarget(Auxiliary.XyzLevelFreeTarget(f,gf,minc,maxc))
		e1:SetOperation(Auxiliary.XyzLevelFreeOperation(f,gf,minc,maxc))
	end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
--Xyz Summon(level free)
function Auxiliary.XyzLevelFreeFilter(c,xyzc,f)
	return (not c:IsOnField() or c:IsFaceup()) and c:IsCanBeXyzMaterial(xyzc) and (not f or f(c,xyzc))
end
function Auxiliary.XyzLevelFreeGoal(g,tp,xyzc,gf)
	if Duel.GetLocationCountFromEx(tp,tp,g,xyzc)<=0 then return false end
	if gf and not gf(g) then return false end
	local lg=g:Filter(Card.IsHasEffect,nil,EFFECT_XYZ_MIN_COUNT)
	for c in Auxiliary.Next(lg) do
		local le=c:IsHasEffect(EFFECT_XYZ_MIN_COUNT)
		local ct=le:GetValue()
		if #g<ct then return false end
	end
	return true
end
function Auxiliary.XyzLevelFreeCondition(f,gf,minct,maxct)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Auxiliary.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function Auxiliary.XyzLevelFreeTarget(f,gf,minct,maxct)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Auxiliary.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,Auxiliary.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzLevelFreeOperation(f,gf,minct,maxct)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--Xyz summon(level free&alterf)
function Auxiliary.XyzLevelFreeConditionAlter(f,gf,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,alterop)
				if (not min or min<=1) and altg:GetCount()>0 then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				mg=mg:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function Auxiliary.XyzLevelFreeTargetAlter(f,gf,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				local altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,alterop)
				local mg2=mg:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				Duel.SetSelectedCard(sg)
				local b1=mg2:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				local b2=(not min or min<=1) and #altg>0
				local g=nil
				local cancel=Duel.IsSummonCancelable()
				if b2 and (not b1 or Duel.SelectYesNo(tp,alterdesc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local tc=altg:SelectUnselect(nil,tp,false,cancel,1,1)
					if tc then
						g=Group.FromCards(tc)
						if alterop then alterop(e,tp,1,tc) end
					end
				else
					e:SetLabel(0)
					Duel.SetSelectedCard(sg)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
					g=mg2:SelectSubGroup(tp,Auxiliary.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
					Auxiliary.GCheckAdditional=nil
				end
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzLevelFreeOperationAlter(f,gf,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end

--Fusion Summon

---Fusion monster, ultimate
---@param fcard Card
---@param sub boolean Can be fusion summoned with substitute material
---@param insf boolean Can be fusion summoned with no material (Instant Fusion)
---@param ... table { min: number, max: number, f: function, code: number, multiple: (string|function)[] }
function Auxiliary.AddFusionProcUltimate(fcard,sub,insf,...)
	if fcard:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			val[i]={ min=1, max=1, f=val[i] }
		elseif type(val[i])=='number' then
			local code=val[i]
			val[i]={ min=1, max=1, code=code }
		end

		if val[i].multiple then
			local multiple_list=val[i].multiple
			val[i].multiple=nil
			local use_code=nil
			for _,item in ipairs(multiple_list) do
				if type(item)=="number" then
					mat[item]=true
					if not use_code then
						use_code=item
					end
				end
			end
			val[i].code=use_code
			val[i].f=function(c,fc,subm,mg,sg)
				for _,fcode in ipairs(multiple_list) do
					if type(fcode)=='function' then
						if fcode(c,fc,subm,mg,sg) and not c:IsHasEffect(6205579) then return true end
					elseif type(fcode)=='number' then
						if c:IsFusionCode(fcode) or (subm and c:CheckFusionSubstitute(fc)) then return true end
					end
				end
				return false
			end
		elseif val[i].code then
			local code=val[i].code
			mat[code]=true
			val[i].f = function(c,fc,subm) return c:IsFusionCode(code) or (subm and c:CheckFusionSubstitute(fc)) end
		else
			local f = val[i].f
			val[i].f = function(c,fc,subm,mg,sg)
				return f(c,fc,subm,mg,sg) and not c:IsHasEffect(6205579)
			end
		end
	end
	local mt=getmetatable(fcard)
	if mt.material==nil then
		mt.material=mat
	end
	if mt.material_count==nil then
		local min=0
		local max=0
		for i=1,#val do
			min=min+val[i].min
			max=max+val[i].max
		end
		mt.material_count={min,max}
	end
	for index,_ in pairs(mat) do
		Auxiliary.AddCodeList(fcard,index)
	end
	local e1=Effect.CreateEffect(fcard)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionUltimate(insf,sub,table.unpack(val)))
	e1:SetOperation(Auxiliary.FOperationUltimate(insf,sub,table.unpack(val)))
	fcard:RegisterEffect(e1)
end

function Auxiliary.FConditionFilterUltimate(c,fc,sub,notfusion,conds)
	local check_type=notfusion and SUMMON_TYPE_SPECIAL or SUMMON_TYPE_FUSION
	if not c:IsCanBeFusionMaterial(fc,check_type) then return false end
	for _,o in ipairs(conds) do
		if o.f(c,fc,sub) then return true end
	end
	return false
end

function Auxiliary.FUltimateGoal(sg,tp,fc,sub,chkfnf,conds)
	for i,o in ipairs(conds) do
		if o.min>0 then
			return false
		end
	end


	local chkf=chkfnf&0xff
	local not_fusion=chkfnf&(0x100|0x200)>0
	if not Auxiliary.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	local g=Group.CreateGroup()
	return (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
		and (not Auxiliary.FGoalCheckAdditional or Auxiliary.FGoalCheckAdditional(tp,sg,fc))
end

function Auxiliary.FUltimateGetCondsResultCode(c,conds,fc,sub,mg,sg)
	-- -1 means crcode is invalid
	if c:IsLocation(LOCATION_MZONE) or Auxiliary.FGoalCheckAdditional then return -1 end

	local code=0
	if sub and c:CheckFusionSubstitute(fc) then
		code=code|0x1
	end
	for i,o in ipairs(conds) do
		if o.max>0 and o.f(c,fc,sub,mg,sg) then
			code=code|(1<<i)
		end
	end
	return code
end

function Auxiliary.FUltimateNext(c,i,mg,sg,tp,fc,sub,chkfnf,conds)
	local not_fusion=chkfnf&(0x100|0x200)>0
	if not not_fusion and Auxiliary.TuneMagicianCheckX(c,sg,EFFECT_TUNE_MAGICIAN_F) then return false end

	sg:AddCard(c)

	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc)
			or chkf~=PLAYER_NONE and Duel.GetLocationCountFromEx(tp,tp,sg,fc)<=0 and not c:IsLocation(LOCATION_MZONE) then
		sg:RemoveCard(c)
		return false
	end

	conds[i].min=conds[i].min-1
	conds[i].max=conds[i].max-1
	local res=Auxiliary.FUltimateGoal(sg,tp,fc,sub,chkfnf,conds)
		or mg:IsExists(Auxiliary.CreateFUltimateCheck(mg,sg,tp,fc,sub,chkfnf,conds),1,sg)
	conds[i].min=conds[i].min+1
	conds[i].max=conds[i].max+1

	sg:RemoveCard(c)
	return res
end

function Auxiliary.FUltimateCheck(c,mg,sg,tp,fc,sub,chkfnf,conds)
	-- we consider unfulfilled conditions first
	local unfulfilled_conds={}
	local fulfilled_conds={}
	
	for i,o in ipairs(conds) do
		if o.min>0 then
			table.insert(unfulfilled_conds, {cond=o, i=i})
		else
			table.insert(fulfilled_conds, {cond=o, i=i})
		end
	end

	local sorted_conds={}
	for _,o in ipairs(unfulfilled_conds) do
		table.insert(sorted_conds, o)
	end
	for _,o in ipairs(fulfilled_conds) do
		table.insert(sorted_conds, o)
	end

	for _,item in ipairs(sorted_conds) do
		local o=item.cond
		local i=item.i
		if o.max>0 then
			if o.f(c,fc,false,mg,sg) and Auxiliary.FUltimateNext(c,i,mg,sg,tp,fc,sub,chkfnf,conds) then
				return true
			elseif sub and o.code and o.f(c,fc,true,mg,sg) and Auxiliary.FUltimateNext(c,i,mg,sg,tp,fc,false,chkfnf,conds) then
				return true
			end
		end
	end

	return false
end

function Auxiliary.CreateFUltimateCheck(mg,sg,tp,fc,sub,chkfnf,conds)
	local crcode_cache={}
	return	function(c)
				local crcode=Auxiliary.FUltimateGetCondsResultCode(c,conds,fc,sub,mg,sg)
				local cached=crcode_cache[crcode]
				if cached then return cached==1 end
				local res=Auxiliary.FUltimateCheck(c,mg,sg,tp,fc,sub,chkfnf,conds)
				if crcode~=-1 then
					crcode_cache[crcode]=res and 1 or 0
				end
				return res
			end
end

function Auxiliary.FUltimateGetNextRoutes(c,mg,sg,tp,fc,chkfnf,routes)
	local next_routes={}

	for _,route in ipairs(routes) do
		local conds=route.conds
		local sub=route.sub
		for i,o in ipairs(conds) do
			if o.max>0 then
				local new_route={ sub=sub, conds={} }

				for j,oo in ipairs(conds) do
					if j==i then
						table.insert(new_route.conds, { min=oo.min-1, max=oo.max-1, f=oo.f, code=oo.code })
					else
						table.insert(new_route.conds, oo)
					end
				end

				local function check_duplicate(sub)
					for _,r in ipairs(next_routes) do
						if r.sub==sub then
							local same=true
							for j,oo in ipairs(r.conds) do
								local cond=new_route.conds[j]
								if oo.min~=cond.min or oo.max~=cond.max then
									same=false
									break
								end
							end
							if same then return true end
						end
					end
					return false
				end

				if o.f(c,fc,false,mg,sg) and not check_duplicate(sub) and Auxiliary.FUltimateNext(c,i,mg,sg,tp,fc,sub,chkfnf,conds) then
					table.insert(next_routes, new_route)
				elseif sub and o.code and o.f(c,fc,true,mg,sg) and not check_duplicate(false) and Auxiliary.FUltimateNext(c,i,mg,sg,tp,fc,false,chkfnf,conds) then
					new_route.sub=false
					table.insert(next_routes, new_route)
				end
			end
		end
	end

	return next_routes
end

function Auxiliary.FConditionUltimate(insf,sub,...)
	--g:Material group(nil for Instant Fusion)
	--gc:Material already used
	--chkf: check field, default:PLAYER_NONE
	--chkf&0x100: Not fusion summon, can use substitute (Hex-Sealed Fusion)
	--chkf&0x200: Not fusion summon, can't use substitute ("Contact Fusion", Neos Fusion)
	local conds={...}
	return	function(e,g,gc,chkfnf)
				if g==nil then return insf and Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
				local c=e:GetHandler()
				local tp=c:GetControler()
				local hexsealed=chkfnf&0x100>0
				local notfusion=chkfnf&0x200>0
				local sub2=(sub or hexsealed) and not notfusion
				local mg=g:Filter(Auxiliary.FConditionFilterUltimate,c,c,sub2,notfusion,conds)
				for _,cond in ipairs(conds) do
					if not mg:IsExists(cond.f,cond.min,nil,c,sub) then return false end
				end
				local checkf=Auxiliary.CreateFUltimateCheck(mg,Group.CreateGroup(),tp,c,sub2,chkfnf,conds)
				if gc then
					if not mg:IsContains(gc) then return false end
					return checkf(gc)
				end
				return mg:IsExists(checkf,1,nil)
			end
end

function Auxiliary.FOperationUltimate(insf,sub,...)
	local conds={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local c=e:GetHandler()
				local hexsealed=chkfnf&0x100>0
				local notfusion=chkfnf&0x200>0
				local sub2=(sub or hexsealed) and not notfusion
				local cancel=notfusion and Duel.GetCurrentChain()==0
				local mg=eg:Filter(Auxiliary.FConditionFilterUltimate,c,c,sub2,notfusion,conds)
				local sg=Group.CreateGroup()
				if gc then sg:AddCard(gc) end
				local current_conds={}
				local total_minc=0
				local total_maxc=0
				for _,o in ipairs(conds) do
					table.insert(current_conds, { min=o.min, max=o.max, f=o.f, code=o.code })
					total_minc=total_minc+o.min
					total_maxc=total_maxc+o.max
				end
				local current_routes = {
					{ sub=sub2, conds=current_conds }
				}
				if gc then
					current_routes = Auxiliary.FUltimateGetNextRoutes(gc,mg,sg,tp,c,chkfnf,current_routes)
				end
				local select_history_cards={}
				local select_history_routes={}
				while sg:GetCount()<total_maxc do
					local crcode_cache={}
					local function select_filter(sc)
						for _,route in ipairs(current_routes) do
							if not crcode_cache[route] then
								crcode_cache[route]={}
							end
							local crcode=Auxiliary.FUltimateGetCondsResultCode(sc,route.conds,c,route.sub,mg,sg)
							local cached=crcode_cache[route][crcode]
							if cached then
								if cached==1 then return true end
							else
								local res=Auxiliary.FUltimateCheck(sc,mg,sg,tp,c,route.sub,chkfnf,route.conds)
								if res then
									if crcode~=-1 then
										crcode_cache[route][crcode]=1
									end
									return true
								elseif crcode~=-1 then
									crcode_cache[route][crcode]=0
								end
							end
						end
						return false
					end
					local cg=mg:Filter(select_filter,sg)
					if cg:GetCount()==0 then
						break
					end

					local finish=false
					for _,route in ipairs(current_routes) do
						if Auxiliary.FUltimateGoal(sg,tp,c,sub2,chkfnf,route.conds) then
							finish=true
							break
						end
					end
					
					local cancel_group=sg:Clone()
					if gc then cancel_group:RemoveCard(gc) end

					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local tc=cg:SelectUnselect(cancel_group,tp,finish,cancel,total_minc,total_maxc)

					if not tc then
						if not finish then sg:Clear() end
						break
					end

					if sg:IsContains(tc) then
						local remove_index=1
						for i=1,#select_history_cards do
							if select_history_cards[i]==tc then
								remove_index=i
								break
							end
						end

						-- revert to old routes
						current_routes=select_history_routes[remove_index]
						while true do
							local rc=table.remove(select_history_cards,remove_index)
							if not rc then break end
							sg:RemoveCard(rc)
							table.remove(select_history_routes,remove_index)
						end
					else
						table.insert(select_history_cards, tc)
						table.insert(select_history_routes, current_routes)
						local next_routes=Auxiliary.FUltimateGetNextRoutes(tc,mg,sg,tp,c,chkfnf,current_routes)
						current_routes=next_routes
						sg:AddCard(tc)
					end
				end
				Duel.SetFusionMaterial(sg)
			end
end

---Fusion monster, mixed materials (fixed count)
---@param fcard Card
---@param sub boolean Can be fusion summoned with substitute material
---@param insf boolean Can be fusion summoned with no material (Instant Fusion)
---@param ... number|function|table
function Auxiliary.AddFusionProcMix(fcard,sub,insf,...)
	if fcard:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local conds={}
	for i=1,#val do
		if type(val[i])=='table' then
			conds[i]={
				min=1,
				max=1,
				miltiple=val[i]
			}
		else
			conds[i]=val[i]
		end
	end
	Auxiliary.AddFusionProcUltimate(fcard,sub,insf,table.unpack(conds))
end


---Fusion monster, mixed material * minc to maxc + material + ...
---@param fcard Card
---@param sub boolean Can be fusion summoned with substitute material
---@param insf boolean Can be fusion summoned with no material (Instant Fusion)
---@param fun1 number|function|table
---@param minc integer
---@param maxc integer
---@param ... number|function|table
function Auxiliary.AddFusionProcMixRep(fcard,sub,insf,fun1,minc,maxc,...)
	if fcard:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={fun1,...}
	local conds={}
	for i=1,#val do
		if type(val[i])=='table' then
			conds[i]={
				min=1,
				max=1,
				miltiple=val[i]
			}
		elseif type(val[i])=='function' then
			conds[i]={
				min=1,
				max=1,
				f=val[i]
			}
		elseif type(val[i])=='number' then
			conds[i]={
				min=1,
				max=1,
				code=val[i]
			}
		end
	end
	conds[1].min=minc
	conds[1].max=maxc
	Auxiliary.AddFusionProcUltimate(fcard,sub,insf,table.unpack(conds))
end

---Fusion monster, name + name
---@param c Card
---@param code1 integer
---@param code2 integer
---@param sub boolean
---@param insf boolean
function Auxiliary.AddFusionProcCode2(c,code1,code2,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2)
end
---Fusion monster, name + name + name
---@param c Card
---@param code1 integer
---@param code2 integer
---@param code3 integer
---@param sub boolean
---@param insf boolean
function Auxiliary.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3)
end
---Fusion monster, name + name + name + name
---@param c Card
---@param code1 integer
---@param code2 integer
---@param code3 integer
---@param code4 integer
---@param sub boolean
---@param insf boolean
function Auxiliary.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3,code4)
end
---Fusion monster, name * n
---@param c Card
---@param code1 integer
---@param cc integer
---@param sub boolean
---@param insf boolean
function Auxiliary.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	Auxiliary.AddFusionProcUltimate(c,sub,insf,{
		min=cc,
		max=cc,
		code=code1
	})
end
---Fusion monster, name * minc to maxc
---@param c Card
---@param code1 integer|table
---@param minc integer
---@param maxc integer
---@param sub boolean
---@param insf boolean
function Auxiliary.AddFusionProcCodeRep2(c,code1,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,code1,minc,maxc)
end
---Fusion monster, name + condition * n
---@param c Card
---@param code1 integer|table
---@param f function|table
---@param cc integer
---@param sub boolean
---@param insf boolean
function Auxiliary.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	Auxiliary.AddFusionProcUltimate(c,sub,insf,code1,{
		min=cc,
		max=cc,
		f=f
	})
end
---Fusion monster, condition + condition
---@param c Card
---@param f1 function|table
---@param f2 function|table
---@param insf boolean
function Auxiliary.AddFusionProcFun2(c,f1,f2,insf)
	Auxiliary.AddFusionProcMix(c,false,insf,f1,f2)
end
---Fusion monster, condition * n
---@param c Card
---@param f function|table
---@param cc integer
---@param insf boolean
function Auxiliary.AddFusionProcFunRep(c,f,cc,insf)
	Auxiliary.AddFusionProcUltimate(c,false,insf,{
		min=cc,
		max=cc,
		f=f
	})
end
---Fusion monster, condition * minc to maxc
---@param c Card
---@param f function|table
---@param minc integer
---@param maxc integer
---@param insf boolean
function Auxiliary.AddFusionProcFunRep2(c,f,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f,minc,maxc)
end
---Fusion monster, condition1 + condition2 * n
---@param c Card
---@param f1 function|table
---@param f2 function|table
---@param cc integer
---@param insf boolean
function Auxiliary.AddFusionProcFunFun(c,f1,f2,cc,insf)
	Auxiliary.AddFusionProcUltimate(c,false,insf,f1,{
		min=cc,
		max=cc,
		f=f2
	})
end
--Fusion monster, condition1 + condition2 * minc to maxc
function Auxiliary.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f2,minc,maxc,f1)
end
---Fusion monster, name + condition * minc to maxc
---@param c Card
---@param code1 integer|table
---@param f function|table
---@param minc integer
---@param maxc integer
---@param sub boolean
---@param insf boolean
function Auxiliary.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1)
end
---Fusion monster, name + name + condition * minc to maxc
---@param c Card
---@param code1 integer|table
---@param code2 integer|table
---@param f function|table
---@param minc integer
---@param maxc integer
---@param sub boolean
---@param insf boolean
function Auxiliary.AddFusionProcCode2FunRep(c,code1,code2,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1,code2)
end
---Fusion monster, Shaddoll materials
---@param c Card
---@param attr integer
function Auxiliary.AddFusionProcShaddoll(c,attr)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FShaddollCondition(attr))
	e1:SetOperation(Auxiliary.FShaddollOperation(attr))
	c:RegisterEffect(e1)
end
function Auxiliary.FShaddollFilter(c,fc,attr)
	return (Auxiliary.FShaddollFilter1(c) or Auxiliary.FShaddollFilter2(c,attr)) and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function Auxiliary.FShaddollExFilter(c,fc,attr,fe)
	return c:IsFaceup() and not c:IsImmuneToEffect(fe) and Auxiliary.FShaddollFilter(c,fc,attr)
end
function Auxiliary.FShaddollFilter1(c)
	return c:IsFusionSetCard(0x9d)
end
function Auxiliary.FShaddollFilter2(c,attr)
	return c:IsFusionAttribute(attr) or c:IsHasEffect(4904633)
end
function Auxiliary.FShaddollSpFilter1(c,fc,tp,mg,exg,attr,chkf)
	return mg:IsExists(Auxiliary.FShaddollSpFilter2,1,c,fc,tp,c,attr,chkf)
		or (exg and exg:IsExists(Auxiliary.FShaddollSpFilter2,1,c,fc,tp,c,attr,chkf))
end
function Auxiliary.FShaddollSpFilter2(c,fc,tp,mc,attr,chkf)
	local sg=Group.FromCards(c,mc)
	if sg:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not Auxiliary.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc)
		or Auxiliary.FGoalCheckAdditional and not Auxiliary.FGoalCheckAdditional(tp,sg,fc) then return false end
	return ((Auxiliary.FShaddollFilter1(c) and Auxiliary.FShaddollFilter2(mc,attr))
		or (Auxiliary.FShaddollFilter2(c,attr) and Auxiliary.FShaddollFilter1(mc)))
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
end
function Auxiliary.FShaddollCondition(attr)
	return 	function(e,g,gc,chkf)
				if g==nil then return Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
				local c=e:GetHandler()
				local mg=g:Filter(Auxiliary.FShaddollFilter,nil,c,attr)
				local tp=e:GetHandlerPlayer()
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				local exg=nil
				if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
					local fe=fc:IsHasEffect(81788994)
					exg=Duel.GetMatchingGroup(Auxiliary.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c,attr,fe)
				end
				if gc then
					if not mg:IsContains(gc) then return false end
					return Auxiliary.FShaddollSpFilter1(gc,c,tp,mg,exg,attr,chkf)
				end
				return mg:IsExists(Auxiliary.FShaddollSpFilter1,1,nil,c,tp,mg,exg,attr,chkf)
			end
end
function Auxiliary.FShaddollOperation(attr)
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
				local c=e:GetHandler()
				local mg=eg:Filter(Auxiliary.FShaddollFilter,nil,c,attr)
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				local exg=nil
				if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
					local fe=fc:IsHasEffect(81788994)
					exg=Duel.GetMatchingGroup(Auxiliary.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c,attr,fe)
				end
				local g=nil
				if gc then
					g=Group.FromCards(gc)
					mg:RemoveCard(gc)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					g=mg:FilterSelect(tp,Auxiliary.FShaddollSpFilter1,1,1,nil,c,tp,mg,exg,attr,chkf)
					mg:Sub(g)
				end
				if exg and exg:IsExists(Auxiliary.FShaddollSpFilter2,1,nil,c,tp,g:GetFirst(),attr,chkf)
					and (mg:GetCount()==0 or (exg:GetCount()>0 and Duel.SelectYesNo(tp,Auxiliary.Stringid(81788994,0)))) then
					fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local sg=exg:FilterSelect(tp,Auxiliary.FShaddollSpFilter2,1,1,nil,c,tp,g:GetFirst(),attr,chkf)
					g:Merge(sg)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local sg=mg:FilterSelect(tp,Auxiliary.FShaddollSpFilter2,1,1,nil,c,tp,g:GetFirst(),attr,chkf)
					g:Merge(sg)
				end
				Duel.SetFusionMaterial(g)
			end
end

--Fusion Summon Effect
function Auxiliary.FMaterialFilter(c,e,tp)
	return c:IsCanBeFusionMaterial()
end
function Auxiliary.FMaterialRemoveFilter(c,e,tp)
	return c:IsAbleToRemove()
end
function Auxiliary.FMaterialToGraveFilter(c,e,tp)
	return c:IsAbleToGrave()
end
function Auxiliary.FMaterialToGrave(mat)
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
end
function Auxiliary.FMaterialRemove(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
end
function Auxiliary.FMaterialToDeck(mat)
	Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
end
---Add Fusion Summon with table `params`.
---@param c Card
---@param params table
---@return Effect
function Auxiliary.AddFusionEffectProcUltimate(c,params)
	--filter,mat_location,mat_filter,mat_operation,gc,reg,get_extra_mat,include_this_card
	--grave_filter,grave_operation,removed_filter,removed_operation,deck_filter,deck_operation,extra_filter,extra_operation
	--get_fcheck,get_gcheck,get_fgoalcheck,foperation,fcheck,gcheck,fgoalcheck,spsummon_nocheck
	--category,opinfo,mat_operation2,foperation2
	if params.mat_location==nil then params.mat_location=LOCATION_HAND+LOCATION_MZONE end
	if params.mat_filter==nil then params.mat_filter=Auxiliary.FMaterialFilter end
	if params.mat_operation==nil then params.mat_operation=Auxiliary.FMaterialToGrave end
	if params.grave_filter==nil then params.grave_filter=Auxiliary.FMaterialRemoveFilter end
	if params.grave_operation==nil then params.grave_operation=Auxiliary.FMaterialRemove end
	if params.removed_operation==nil then params.removed_operation=params.mat_operation end
	if params.deck_filter==nil then params.deck_filter=Auxiliary.FMaterialToGraveFilter end
	if params.deck_operation==nil then params.deck_operation=params.mat_operation end
	if params.extra_filter==nil then params.extra_filter=Auxiliary.FMaterialToGraveFilter end
	if params.extra_operation==nil then params.extra_operation=params.mat_operation end
	if params.spsummon_nocheck==nil then params.spsummon_nocheck=false end
	if params.category==nil then params.category=0 end
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_FUSION_SUMMON|params.category)
	e1:SetTarget(Auxiliary.FusionEffectUltimateTarget(params))
	e1:SetOperation(Auxiliary.FusionEffectUltimateOperation(params))
	if params.reg~=false then
		e1:SetType(EFFECT_TYPE_ACTIVATE)
		e1:SetCode(EVENT_FREE_CHAIN)
		c:RegisterEffect(e1)
	end
	return e1
end
Auxiliary.FMaterialBase=nil
function Auxiliary.FusionEffectUltimateFilter(c,e,tp,mg,chkf,params)
	--mg,gc,f1,f2,get_fcheck,spsummon_nocheck
	if not c:IsType(TYPE_FUSION) then return false end
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,params.spsummon_nocheck,false) then return false end
	if params.filter1 and not params.filter1(c) then return false end
	if params.filter2 and not params.filter2(c) then return false end
	if params.get_fcheck then Auxiliary.FCheckAdditional=params.get_fcheck(c,e,tp) end
	local res=c:CheckFusionMaterial(mg,params.gc,chkf)
	if params.get_fcheck then Auxiliary.FCheckAdditional=nil end
	return res
end
function Auxiliary.FusionEffectUltimateMatFilter(c,e,tp,f)
	return not c:IsImmuneToEffect(e) and not f or f(c,e,tp)
end
function Auxiliary.FusionEffectUltimateMatLocFilter(c,e,tp,loc,f)
	return not c:IsLocation(loc) or (not f or f(c,e,tp))
end
function Auxiliary.FusionEffectUltimateTarget(params)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local chkf=tp
					local gc
					if params.include_this_card then
						gc=e:GetHandler()
					end
					local mgall,mgbase=Duel.GetFusionMaterial(tp,params.mat_location)
					local mgex=Group.CreateGroup()
					if params.get_extra_mat then mgex=params.get_extra_mat(e,tp,eg,ep,ev,re,r,rp) end
					mgall:Merge(mgex)
					mgbase:Merge(mgex)
					local mg1=mgall:Filter(Auxiliary.FusionEffectUltimateMatFilter,nil,e,tp,params.mat_filter)
						:Filter(Auxiliary.FusionEffectUltimateMatLocFilter,nil,e,tp,LOCATION_GRAVE,params.grave_filter)
						:Filter(Auxiliary.FusionEffectUltimateMatLocFilter,nil,e,tp,LOCATION_REMOVED,params.removed_filter)
						:Filter(Auxiliary.FusionEffectUltimateMatLocFilter,nil,e,tp,LOCATION_DECK,params.deck_filter)
						:Filter(Auxiliary.FusionEffectUltimateMatLocFilter,nil,e,tp,LOCATION_EXTRA,params.extra_filter)
					if gc then mg1:AddCard(gc) end
					Auxiliary.FMaterialBase=mgbase:Filter(Auxiliary.IsInGroup,nil,mg1)
					Auxiliary.FCheckAdditional=params.fcheck
					Auxiliary.GCheckAdditional=params.gcheck
					if params.get_gcheck then
						Auxiliary.GCheckAdditional=params.get_gcheck(e,tp,nil)
					end
					Auxiliary.FGoalCheckAdditional=params.fgoalcheck
					local res=Duel.IsExistingMatchingCard(Auxiliary.FusionEffectUltimateFilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,chkf,{
						filter1=params.filter,
						gc=gc,
						get_fcheck=params.get_fcheck,
						spsummon_nocheck=params.spsummon_nocheck
					})
					Auxiliary.FCheckAdditional=nil
					Auxiliary.GCheckAdditional=nil
					if not res then
						local ce=Duel.GetChainMaterial(tp)
						if ce~=nil then
							local fgroup=ce:GetTarget()
							local mg2=fgroup(ce,e,tp):Filter(Auxiliary.FusionEffectUltimateMatFilter,nil,e,tp,params.mat_filter)
							local mf=ce:GetValue()
							res=Duel.IsExistingMatchingCard(Auxiliary.FusionEffectUltimateFilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,chkf,{
								filter1=params.filter,
								filter2=mf,
								gc=gc,
								get_fcheck=params.get_fcheck
							})
						end
					end
					Auxiliary.FMaterialBase=nil
					Auxiliary.FGoalCheckAdditional=nil
					return res
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
				if params.mat_operation==Auxiliary.FMaterialRemove
					or params.grave_operation==Auxiliary.FMaterialRemove
					or params.deck_operation==Auxiliary.FMaterialRemove then
					Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,params.mat_location)
					e:SetCategory(e:GetCategory()|CATEGORY_REMOVE)
				end
				if params.mat_operation==Auxiliary.FMaterialToDeck
					or params.grave_operation==Auxiliary.FMaterialToDeck
					or params.deck_operation==Auxiliary.FMaterialToDeck then
					Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,params.mat_location)
					e:SetCategory(e:GetCategory()|CATEGORY_TODECK)
				end
				if params.mat_location&LOCATION_DECK>0 then
					e:SetCategory(e:GetCategory()|CATEGORY_DECKDES)
				end
				if params.opinfo then
					params.opinfo(e,tp)
				end
			end
end
---
---@param params table
---@return function
function Auxiliary.FusionEffectUltimateOperation(params)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local chkf=tp
				local gc
				if params.include_this_card then
					gc=e:GetHandler()
					if gc:IsOnField() and gc:IsFacedown() or not gc:IsRelateToEffect(e) or gc:IsImmuneToEffect(e) then return end
				end
				local mgall,mgbase=Duel.GetFusionMaterial(tp,params.mat_location)
				local mgex=Group.CreateGroup()
				if params.get_extra_mat then mgex=params.get_extra_mat(e,tp,eg,ep,ev,re,r,rp) end
				mgall:Merge(mgex)
				mgbase:Merge(mgex)
				local mg1=mgall:Filter(Auxiliary.FusionEffectUltimateMatFilter,nil,e,tp,params.mat_filter)
					:Filter(Auxiliary.FusionEffectUltimateMatLocFilter,nil,e,tp,LOCATION_GRAVE,params.grave_filter)
					:Filter(Auxiliary.FusionEffectUltimateMatLocFilter,nil,e,tp,LOCATION_REMOVED,params.removed_filter)
					:Filter(Auxiliary.FusionEffectUltimateMatLocFilter,nil,e,tp,LOCATION_DECK,params.deck_filter)
					:Filter(Auxiliary.FusionEffectUltimateMatLocFilter,nil,e,tp,LOCATION_EXTRA,params.extra_filter)
				if gc then mg1:AddCard(gc) end
				Auxiliary.FMaterialBase=mgbase:Filter(Auxiliary.IsInGroup,nil,mg1)
				Auxiliary.FCheckAdditional=params.fcheck
				Auxiliary.GCheckAdditional=params.gcheck
				if params.get_gcheck then
					Auxiliary.GCheckAdditional=params.get_gcheck(e,tp,nil)
				end
				Auxiliary.FGoalCheckAdditional=params.fgoalcheck
				local sg1=Duel.GetMatchingGroup(Auxiliary.FusionEffectUltimateFilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,chkf,{
					filter1=params.filter,
					gc=gc,
					get_fcheck=params.get_fcheck,
					spsummon_nocheck=params.spsummon_nocheck
				})
				Auxiliary.FCheckAdditional=nil
				Auxiliary.GCheckAdditional=nil
				local mg2=nil
				local sg2=nil
				local ce=Duel.GetChainMaterial(tp)
				if ce then
					local fgroup=ce:GetTarget()
					mg2=fgroup(ce,e,tp):Filter(Auxiliary.FusionEffectUltimateMatFilter,nil,e,tp,params.mat_filter)
					local mf=ce:GetValue()
					sg2=Duel.GetMatchingGroup(Auxiliary.FusionEffectUltimateFilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,chkf,{
						filter1=params.filter,
						filter2=mf,
						gc=gc,
						get_fcheck=params.get_fcheck
					})
				end
				if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
					local sg=sg1:Clone()
					if sg2 then sg:Merge(sg2) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=sg:Select(tp,1,1,nil)
					local tc=tg:GetFirst()
					Auxiliary.FCheckAdditional=params.fcheck
					Auxiliary.GCheckAdditional=params.gcheck
					if params.get_gcheck then
						Auxiliary.GCheckAdditional=params.get_gcheck(e,tp,tc)
					end
					if params.get_fcheck then Auxiliary.FCheckAdditional=params.get_fcheck(tc,e,tp) end
					if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
						local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,gc,chkf)
						tc:SetMaterial(mat1)
						if params.mat_operation2 then params.mat_operation2(e,tp,mat1) end
						if params.grave_operation~=params.mat_operation then
							local mat=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
							mat1:Sub(mat)
							params.grave_operation(mat)
						end
						if params.removed_operation~=params.mat_operation then
							local mat=mat1:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
							mat1:Sub(mat)
							params.removed_operation(mat)
						end
						if params.deck_operation~=params.mat_operation then
							local mat=mat1:Filter(Card.IsLocation,nil,LOCATION_DECK)
							mat1:Sub(mat)
							params.deck_operation(mat)
						end
						if params.extra_operation~=params.mat_operation then
							local mat=mat1:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
							mat1:Sub(mat)
							params.extra_operation(mat)
						end
						params.mat_operation(mat1)
						Duel.BreakEffect()
						Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,params.spsummon_nocheck,false,POS_FACEUP)
					elseif ce and mg2 then
						local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,gc,chkf)
						local fop=ce:GetOperation()
						fop(ce,e,tp,tc,mat2)
					end
					tc:CompleteProcedure()
					if params.foperation then params.foperation(e,tp,tc) end
				end
				Auxiliary.FCheckAdditional=nil
				Auxiliary.GCheckAdditional=nil
				Auxiliary.FGoalCheckAdditional=nil
				Auxiliary.FMaterialBase=nil
				if params.foperation2 then params.foperation2(e,tp,eg,ep,ev,re,r,rp) end
			end
end
function Auxiliary.AddFusionEffectProc(c,filter,mat_location,mat_filter,mat_operation,params)
	if params==nil then params={} end
	params.filter=filter
	params.mat_location=mat_location
	params.mat_filter=mat_filter
	params.mat_operation=mat_operation
	return Auxiliary.AddFusionEffectProcUltimate(c,params)
end

--Contact Fusion
function Auxiliary.AddContactFusionProcedure(c,filter,self_location,opponent_location,mat_operation,...)
	self_location=self_location or 0
	opponent_location=opponent_location or 0
	local operation_params={...}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.ContactFusionCondition(filter,self_location,opponent_location))
	e2:SetTarget(Auxiliary.ContactFusionTarget(filter,self_location,opponent_location))
	e2:SetOperation(Auxiliary.ContactFusionOperation(mat_operation,operation_params))
	c:RegisterEffect(e2)
	return e2
end
function Auxiliary.ContactFusionMaterialFilter(c,fc,filter)
	return c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL) and (not filter or filter(c,fc))
end
function Auxiliary.ContactFusionCondition(filter,self_location,opponent_location)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				return c:CheckFusionMaterial(mg,nil,tp|0x200)
			end
end
function Auxiliary.ContactFusionTarget(filter,self_location,opponent_location)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|0x200)
				if #g>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.ContactFusionOperation(mat_operation,operation_params)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				mat_operation(g,table.unpack(operation_params))
				g:DeleteGroup()
			end
end
--send to deck of contact fusion
function Auxiliary.tdcfop(c)
	return	function(g)
				local cg=g:Filter(Card.IsFacedown,nil)
				if cg:GetCount()>0 then
					Duel.ConfirmCards(1-c:GetControler(),cg)
				end
				local hg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
				if hg:GetCount()>0 then
					Duel.HintSelection(hg)
				end
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
			end
end

--Ritual Summon
function Auxiliary.AddRitualProcUltimate(c,filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	summon_location=summon_location or LOCATION_HAND
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RitualUltimateTarget(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_target))
	e1:SetOperation(Auxiliary.RitualUltimateOperation(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_operation))
	if not pause then
		c:RegisterEffect(e1)
	end
	return e1
end
---@param g Group
---@param c Card
---@param lv integer
---@return boolean
function Auxiliary.RitualCheckGreater(g,c,lv)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetRitualLevel,lv,c)
end
---@param g Group
---@param c Card
---@param lv integer
---@return boolean
function Auxiliary.RitualCheckEqual(g,c,lv)
	return g:CheckWithSumEqual(Card.GetRitualLevel,lv,#g,#g,c)
end
---@param g Group
---@param tp integer
---@param c Card
---@param lv integer
---@param greater_or_equal string
---|"'Greater'"
---|"'Equal'"
---@return boolean
function Auxiliary.RitualCheck(g,tp,c,lv,greater_or_equal)
	return Auxiliary["RitualCheck"..greater_or_equal](g,c,lv) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not Auxiliary.RCheckAdditional or Auxiliary.RCheckAdditional(tp,g,c))
end
function Auxiliary.RitualCheckAdditionalLevel(c,rc)
	local raw_level=c:GetRitualLevel(rc)
	local lv1=raw_level&0xffff
	local lv2=raw_level>>16
	if lv2>0 then
		return math.min(lv1,lv2)
	else
		return lv1
	end
end
function Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	if greater_or_equal=="Equal" then
		return	function(g)
					return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g)) and g:GetSum(Auxiliary.RitualCheckAdditionalLevel,c)<=lv
				end
	else
		return	function(g,ec)
					if ec then
						return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g,ec)) and g:GetSum(Auxiliary.RitualCheckAdditionalLevel,c)-Auxiliary.RitualCheckAdditionalLevel(ec,c)<=lv
					else
						return not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g)
					end
				end
	end
end
function Auxiliary.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function Auxiliary.RitualExtraFilter(c,f)
	return c:GetLevel()>0 and f(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function Auxiliary.RitualUltimateTarget(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_target)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetRitualMaterial(tp)
					if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp,true) end
					local exg=nil
					if grave_filter then
						exg=Duel.GetMatchingGroup(Auxiliary.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
					end
					return Duel.IsExistingMatchingCard(Auxiliary.RitualUltimateFilter,tp,summon_location,0,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal,true)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,summon_location)
				if grave_filter then
					Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
				end
				if extra_target then
					extra_target(e,tp,eg,ep,ev,re,r,rp)
				end
			end
end
function Auxiliary.RitualUltimateOperation(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_operation)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				::RitualUltimateSelectStart::
				local mg=Duel.GetRitualMaterial(tp)
				if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp) end
				local exg=nil
				if grave_filter then
					exg=Duel.GetMatchingGroup(Auxiliary.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,Auxiliary.NecroValleyFilter(Auxiliary.RitualUltimateFilter),tp,summon_location,0,1,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal)
				local tc=tg:GetFirst()
				local mat
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					if exg then
						mg:Merge(exg)
					end
					if tc.mat_filter then
						mg=mg:Filter(tc.mat_filter,tc,tp)
					else
						mg:RemoveCard(tc)
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local lv=level_function(tc)
					Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,lv,greater_or_equal)
					mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,true,1,lv,tp,tc,lv,greater_or_equal)
					Auxiliary.GCheckAdditional=nil
					if not mat then goto RitualUltimateSelectStart end
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
				if extra_operation then
					extra_operation(e,tp,eg,ep,ev,re,r,rp,tc,mat)
				end
			end
end
--Ritual Summon, geq fixed lv
function Auxiliary.AddRitualProcGreater(c,filter,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetOriginalLevel,"Greater",summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcGreaterCode(c,code1,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1)
	return Auxiliary.AddRitualProcGreater(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
--Ritual Summon, equal to fixed lv
function Auxiliary.AddRitualProcEqual(c,filter,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetOriginalLevel,"Equal",summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcEqualCode(c,code1,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1)
	return Auxiliary.AddRitualProcEqual(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
--Ritual Summon, equal to monster lv
function Auxiliary.AddRitualProcEqual2(c,filter,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetLevel,"Equal",summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcEqual2Code(c,code1,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1)
	return Auxiliary.AddRitualProcEqual2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcEqual2Code2(c,code1,code2,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1,code2)
	return Auxiliary.AddRitualProcEqual2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1,code2),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
--Ritual Summon, geq monster lv
function Auxiliary.AddRitualProcGreater2(c,filter,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetLevel,"Greater",summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcGreater2Code(c,code1,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1)
	return Auxiliary.AddRitualProcGreater2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcGreater2Code2(c,code1,code2,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1,code2)
	return Auxiliary.AddRitualProcGreater2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1,code2),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end

--Pendulum Summon
--add procedure to Pendulum monster, also allows registeration of activation effect
function Auxiliary.EnablePendulumAttribute(c,reg)
	if not Auxiliary.PendulumChecklist then
		Auxiliary.PendulumChecklist=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(Auxiliary.PendulumReset)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(Auxiliary.PendCondition)
	e1:SetOperation(Auxiliary.PendOperation)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	--register by default
	if reg==nil or reg then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1160)
		e2:SetType(EFFECT_TYPE_ACTIVATE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_HAND)
		c:RegisterEffect(e2)
	end
end
function Auxiliary.PendulumReset(e,tp,eg,ep,ev,re,r,rp)
	Auxiliary.PendulumChecklist=0
end
function Auxiliary.PConditionExtraFilterSpecific(c,e,tp,lscale,rscale,te)
	if not te then return true end
	local f=te:GetValue()
	return not f or f(te,c,e,tp,lscale,rscale)
end
function Auxiliary.PConditionExtraFilter(c,e,tp,lscale,rscale,eset)
	for _,te in ipairs(eset) do
		if Auxiliary.PConditionExtraFilterSpecific(c,e,tp,lscale,rscale,te) then return true end
	end
	return false
end
function Auxiliary.PConditionFilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=Auxiliary.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
		and (Auxiliary.PendulumChecklist&(0x1<<tp)==0 or Auxiliary.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end
function Auxiliary.PendCondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	if Auxiliary.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or c==rpz then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(Auxiliary.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
end
function Auxiliary.PendOperationCheck(ft1,ft2,ft)
	return	function(g)
				local exg=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
				local mg=g-exg
				return #g<=ft and #exg<=ft2 and #mg<=ft1
			end
end
function Auxiliary.PendOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local tg=nil
	local loc=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	if ft1>0 then loc=loc|LOCATION_HAND end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(Auxiliary.PConditionFilter,nil,e,tp,lscale,rscale,eset)
	else
		tg=Duel.GetMatchingGroup(Auxiliary.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
	end
	local ce=nil
	local b1=Auxiliary.PendulumChecklist&(0x1<<tp)==0
	local b2=#eset>0
	if b1 and b2 then
		local options={1163}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		if op>0 then
			ce=eset[op]
		end
	elseif b2 and not b1 then
		local options={}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		ce=eset[op+1]
	end
	if ce then
		tg=tg:Filter(Auxiliary.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Auxiliary.GCheckAdditional=Auxiliary.PendOperationCheck(ft1,ft2,ft)
	local g=tg:SelectSubGroup(tp,Auxiliary.TRUE,true,1,math.min(#tg,ft))
	Auxiliary.GCheckAdditional=nil
	if not g then return end
	if ce then
		Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
		ce:UseCountLimit(tp)
	else
		Auxiliary.PendulumChecklist=Auxiliary.PendulumChecklist|(0x1<<tp)
	end
	sg:Merge(g)
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
--enable revive limit for monsters that are also pendulum sumonable from certain locations (Odd-Eyes Revolution Dragon)
function Auxiliary.EnableReviveLimitPendulumSummonable(c, loc)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	c:EnableReviveLimit()
	local mt=getmetatable(c)
	if loc==nil then loc=0xff end
	mt.psummonable_location=loc
	--complete procedure on pendulum summon success
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(Auxiliary.PSSCompleteProcedure)
	c:RegisterEffect(e1)
end
function Auxiliary.PendulumSummonableBool(c)
	return c.psummonable_location~=nil and c:GetLocation()&c.psummonable_location>0
end
function Auxiliary.PSSCompleteProcedure(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_PENDULUM) then
		c:CompleteProcedure()
	end
end

---Link Summon
---@param c Card
---@param f function|nil
---@param min integer
---@param max? integer
---@param gf? function
---@return Effect
function Auxiliary.AddLinkProcedure(c,f,min,max,gf)
	if max==nil then max=c:GetLink() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.LinkCondition(f,min,max,gf))
	e1:SetTarget(Auxiliary.LinkTarget(f,min,max,gf))
	e1:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.LConditionFilter(c,f,lc,e)
	return (c:IsFaceup() or not c:IsOnField() or e:IsHasProperty(EFFECT_FLAG_SET_AVAILABLE))
		and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
end
function Auxiliary.LExtraFilter(c,f,lc,tp)
	if c:IsOnField() and c:IsFacedown() then return false end
	if not c:IsCanBeLinkMaterial(lc) or f and not f(c) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local tf=te:GetValue()
		local related,valid=tf(te,lc,nil,c,tp)
		if related then return true end
	end
	return false
end
function Auxiliary.GetLinkCount(c)
	if c:IsLinkType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function Auxiliary.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc,e)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function Auxiliary.LCheckOtherMaterial(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	local res1=false
	local res2=true
	for _,te in pairs(le) do
		local f=te:GetValue()
		local related,valid=f(te,lc,mg,c,tp)
		if related then res2=false end
		if related and valid then res1=true end
	end
	return res1 or res2
end
function Auxiliary.LUncompatibilityFilter(c,sg,lc,tp)
	local mg=sg:Filter(Auxiliary.TRUE,c)
	return not Auxiliary.LCheckOtherMaterial(c,mg,lc,tp)
end
function Auxiliary.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg,lc,tp))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function Auxiliary.LExtraMaterialCount(mg,lc,tp)
	for tc in Auxiliary.Next(mg) do
		local le={tc:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
		for _,te in pairs(le) do
			local sg=mg:Filter(Auxiliary.TRUE,tc)
			local f=te:GetValue()
			local related,valid=f(te,lc,sg,tc,tp)
			if related and valid then
				te:UseCountLimit(tp)
			end
		end
	end
end
function Auxiliary.LinkCondition(f,minct,maxct,gf)
	return	function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function Auxiliary.LinkTarget(f,minct,maxct,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function Auxiliary.LinkOperation(f,minct,maxct,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Auxiliary.LExtraMaterialCount(g,c,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end

--Must use X as material
function Auxiliary.MustMaterialCheck(v,tp,code)
	local g=Duel.GetMustMaterial(tp,code)
	if not v then
		if code==EFFECT_MUST_BE_XMATERIAL and Duel.IsPlayerAffectedByEffect(tp,67120578) then return false end
		if code==EFFECT_MUST_BE_SMATERIAL and Duel.IsPlayerAffectedByEffect(tp,8173184) then return false end
		return #g==0
	end
	return Duel.CheckMustMaterial(tp,v,code)
end
function Auxiliary.MustMaterialCounterFilter(c,g)
	return not g:IsContains(c)
end

--Summon Condition
--sp_summon condition for fusion monster
function Auxiliary.fuslimit(e,se,sp,st)
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
--sp_summon condition for ritual monster
function Auxiliary.ritlimit(e,se,sp,st)
	return st&SUMMON_TYPE_RITUAL==SUMMON_TYPE_RITUAL
end
--sp_summon condition for synchro monster
function Auxiliary.synlimit(e,se,sp,st)
	return st&SUMMON_TYPE_SYNCHRO==SUMMON_TYPE_SYNCHRO
end
--sp_summon condition for xyz monster
function Auxiliary.xyzlimit(e,se,sp,st)
	return st&SUMMON_TYPE_XYZ==SUMMON_TYPE_XYZ
end
--sp_summon condition for pendulum monster
function Auxiliary.penlimit(e,se,sp,st)
	return st&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM
end
--sp_summon condition for link monster
function Auxiliary.linklimit(e,se,sp,st)
	return st&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK
end
--sp_summon condition for /Assault Mode
function Auxiliary.AssaultModeLimit(e,se,sp,st)
	return st==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_ASSAULT_MODE or se:GetHandler():IsCode(80280737)
end
--sp_summon condition for Masked HERO
function Auxiliary.MaskChangeLimit(e,se,sp,st)
	return st==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_MASK_CHANGE or se:GetHandler():IsCode(21143940)
end
--sp_summon condition for Evil HERO
function Auxiliary.DarkFusionLimit(e,se,sp,st)
	return se:GetHandler():IsCode(94820406)
		or st==SUMMON_VALUE_DARK_FUSION
		or (Duel.IsPlayerAffectedByEffect(sp,72043279) and st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION)
end
--sp_summon condition for Fossil
function Auxiliary.FossilFusionLimit(e,se,sp,st)
	return st==SUMMON_VALUE_FOSSIL_FUSION or se:GetHandler():IsCode(59419719)
		or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

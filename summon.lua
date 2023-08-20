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
	e2:SetCondition(aux.DualNormalCondition)
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
--Synchro monster, 1 tuner + min to max monsters
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
function Auxiliary.SynCondition(f1,f2,minc,maxc)
	return	function(e,c,smat,mg,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
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
function Auxiliary.SynTarget(f1,f2,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
				local minc=minc
				local maxc=maxc
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
--Synchro monster, f1~f3 each 1 MONSTER + f4 min to max monsters
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
function Auxiliary.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc)
	return	function(e,c,smat,mg1,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				if smat and not smat:IsCanBeSynchroMaterial(c) then return false end
				local tp=c:GetControler()
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1
					mgchk=true
				else
					mg=Auxiliary.GetSynMaterials(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				return mg:IsExists(Auxiliary.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk)
			end
end
function Auxiliary.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				::SynMixTargetSelectStart::
				local g=Group.CreateGroup()
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1
					mgchk=true
				else
					mg=Auxiliary.GetSynMaterials(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				local c1
				local c2
				local c3
				local cancel=Duel.IsSummonCancelable()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				c1=mg:Filter(Auxiliary.SynMixFilter1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
				if not c1 then return false end
				g:AddCard(c1)
				if f2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					c2=mg:Filter(Auxiliary.SynMixFilter2,g,f2,f3,f4,minc,maxc,c,mg,smat,c1,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
					if not c2 then return false end
					if g:IsContains(c2) then goto SynMixTargetSelectStart end
					g:AddCard(c2)
					if f3 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
						c3=mg:Filter(Auxiliary.SynMixFilter3,g,f3,f4,minc,maxc,c,mg,smat,c1,c2,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
						if not c3 then return false end
						if g:IsContains(c3) then goto SynMixTargetSelectStart end
						g:AddCard(c3)
					end
				end
				local g4=Group.CreateGroup()
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
						else return false end
					end
					if g:IsContains(c4) or g4:IsContains(c4) then goto SynMixTargetSelectStart end
					g4:AddCard(c4)
				end
				g:Merge(g4)
				if g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.SynMixOperation(f1,f2,f3,f4,minct,maxc,gc)
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
function Auxiliary.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if gc and not gc(g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not Auxiliary.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	if not g:CheckWithSumEqual(Card.GetSynchroLevel,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard)
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(Auxiliary.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
		then return false end
	local hg=g:Filter(Auxiliary.SynMixHandFilter,nil,tp,syncard)
	local hct=hg:GetCount()
	if hct>0 and not mgchk then
		local found=false
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(Auxiliary.SynLimitFilter,1,c,hf,he,syncard) then return false end
				if (hmin and hct<hmin) or (hmax and hct>hmax) then return false end
			end
		end
		if not found then return false end
	end
	for c in aux.Next(g) do
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
		and Auxiliary.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and (not alterop or alterop(e,tp,0,c))
end
--Xyz monster, lv k*n
function Auxiliary.AddXyzProcedure(c,f,lv,ct,alterf,alterdesc,maxct,alterop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if not maxct then maxct=ct end
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
function Auxiliary.XyzCondition(f,lv,minc,maxc)
	--og: use special material
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function Auxiliary.XyzTarget(f,lv,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
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
function Auxiliary.XyzOperation(f,lv,minc,maxc)
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
function Auxiliary.XyzConditionAlter(f,lv,minc,maxc,alterf,alterdesc,alterop)
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
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function Auxiliary.XyzTargetAlter(f,lv,minc,maxc,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
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
function Auxiliary.XyzOperationAlter(f,lv,minc,maxc,alterf,alterdesc,alterop)
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
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
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
--material: names in material list
--Fusion monster, mixed materials
function Auxiliary.AddFusionProcMix(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,mg,sg) return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) end
		elseif type(val[i])=='table' then
			fun[i]=function(c,fc,sub,mg,sg)
					for _,fcode in ipairs(val[i]) do
						if type(fcode)=='function' then
							if fcode(c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) then return true end
						else
							if c:IsFusionCode(fcode) or (sub and c:CheckFusionSubstitute(fc)) then return true end
						end
					end
					return false
			end
			for _,fcode in ipairs(val[i]) do
				if type(fcode)~='function' then mat[fcode]=true end
			end
		else
			fun[i]=function(c,fc,sub) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) end
			mat[val[i]]=true
		end
	end
	local mt=getmetatable(c)
	if mt.material==nil then
		mt.material=mat
	end
	if mt.material_count==nil then
		mt.material_count={#fun,#fun}
	end
	for index,_ in pairs(mat) do
		Auxiliary.AddCodeList(c,index)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMix(insf,sub,table.unpack(fun)))
	e1:SetOperation(Auxiliary.FOperationMix(insf,sub,table.unpack(fun)))
	c:RegisterEffect(e1)
end
function Auxiliary.FConditionMix(insf,sub,...)
	--g:Material group(nil for Instant Fusion)
	--gc:Material already used
	--chkf: check field, default:PLAYER_NONE
	--chkf&0x100: Not fusion summon
	--chkf&0x200: Concat fusion
	local funs={...}
	return	function(e,g,gc,chkfnf)
				if g==nil then return insf and Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,concat_fusion,table.unpack(funs))
				if gc then
					if not mg:IsContains(gc) then return false end
					Duel.SetSelectedCard(gc)
				end
				return mg:CheckSubGroup(Auxiliary.FCheckMixGoal,#funs,#funs,tp,c,sub,chkfnf,table.unpack(funs))
			end
end
function Auxiliary.FOperationMix(insf,sub,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,concat_fusion,table.unpack(funs))
				if gc then Duel.SetSelectedCard(gc) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:SelectSubGroup(tp,Auxiliary.FCheckMixGoal,false,#funs,#funs,tp,c,sub,chkfnf,table.unpack(funs))
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FConditionFilterMix(c,fc,sub,concat_fusion,...)
	local fusion_type=concat_fusion and SUMMON_TYPE_SPECIAL or SUMMON_TYPE_FUSION
	if not c:IsCanBeFusionMaterial(fc,fusion_type) then return false end
	for i,f in ipairs({...}) do
		if f(c,fc,sub) then return true end
	end
	return false
end
function Auxiliary.FCheckMix(c,mg,sg,fc,sub,fun1,fun2,...)
	if fun2 then
		sg:AddCard(c)
		local res=false
		if fun1(c,fc,false,mg,sg) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,sub,fun2,...)
		elseif sub and fun1(c,fc,true,mg,sg) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,false,fun2,...)
		end
		sg:RemoveCard(c)
		return res
	else
		return fun1(c,fc,sub,mg,sg)
	end
end
--if sg1 is subset of sg2 then not Auxiliary.FCheckAdditional(tp,sg1,fc) -> not Auxiliary.FCheckAdditional(tp,sg2,fc)
Auxiliary.FCheckAdditional=nil
Auxiliary.FGoalCheckAdditional=nil
function Auxiliary.FCheckMixGoal(sg,tp,fc,sub,chkfnf,...)
	local chkf=chkfnf&0xff
	local concat_fusion=chkfnf&0x200>0
	if not concat_fusion and sg:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not Auxiliary.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	local g=Group.CreateGroup()
	return sg:IsExists(Auxiliary.FCheckMix,1,nil,sg,g,fc,sub,...) and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
		and (not Auxiliary.FCheckAdditional or Auxiliary.FCheckAdditional(tp,sg,fc))
		and (not Auxiliary.FGoalCheckAdditional or Auxiliary.FGoalCheckAdditional(tp,sg,fc))
end
--Fusion monster, mixed material * minc to maxc + material + ...
function Auxiliary.AddFusionProcMixRep(c,sub,insf,fun1,minc,maxc,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={fun1,...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,mg,sg) return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) end
		elseif type(val[i])=='table' then
			fun[i]=function(c,fc,sub,mg,sg)
					for _,fcode in ipairs(val[i]) do
						if type(fcode)=='function' then
							if fcode(c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) then return true end
						else
							if c:IsFusionCode(fcode) or (sub and c:CheckFusionSubstitute(fc)) then return true end
						end
					end
					return false
			end
			for _,fcode in ipairs(val[i]) do
				if type(fcode)~='function' then mat[fcode]=true end
			end
		else
			fun[i]=function(c,fc,sub) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) end
			mat[val[i]]=true
		end
	end
	local mt=getmetatable(c)
	if mt.material==nil then
		mt.material=mat
	end
	if mt.material_count==nil then
		mt.material_count={#fun+minc-1,#fun+maxc-1}
	end
	for index,_ in pairs(mat) do
		Auxiliary.AddCodeList(c,index)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
	e1:SetOperation(Auxiliary.FOperationMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
	c:RegisterEffect(e1)
end
function Auxiliary.FConditionMixRep(insf,sub,fun1,minc,maxc,...)
	local funs={...}
	return	function(e,g,gc,chkfnf)
				if g==nil then return insf and Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,concat_fusion,fun1,table.unpack(funs))
				if gc then
					if not mg:IsContains(gc) then return false end
					local sg=Group.CreateGroup()
					return Auxiliary.FSelectMixRep(gc,tp,mg,sg,c,sub,chkfnf,fun1,minc,maxc,table.unpack(funs))
				end
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.FSelectMixRep,1,nil,tp,mg,sg,c,sub,chkfnf,fun1,minc,maxc,table.unpack(funs))
			end
end
function Auxiliary.FOperationMixRep(insf,sub,fun1,minc,maxc,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,concat_fusion,fun1,table.unpack(funs))
				local sg=Group.CreateGroup()
				if gc then sg:AddCard(gc) end
				while sg:GetCount()<maxc+#funs do
					local cg=mg:Filter(Auxiliary.FSelectMixRep,sg,tp,mg,sg,c,sub,chkfnf,fun1,minc,maxc,table.unpack(funs))
					if cg:GetCount()==0 then break end
					local finish=Auxiliary.FCheckMixRepGoal(tp,sg,c,sub,chkfnf,fun1,minc,maxc,table.unpack(funs))
					local cancel_group=sg:Clone()
					if gc then cancel_group:RemoveCard(gc) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local tc=cg:SelectUnselect(cancel_group,tp,finish,false,minc+#funs,maxc+#funs)
					if not tc then break end
					if sg:IsContains(tc) then
						sg:RemoveCard(tc)
					else
						sg:AddCard(tc)
					end
				end
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FCheckMixRep(sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	if fun2 then
		return sg:IsExists(Auxiliary.FCheckMixRepFilter,1,g,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	else
		local ct1=sg:FilterCount(fun1,g,fc,sub,mg,sg)
		local ct2=sg:FilterCount(fun1,g,fc,false,mg,sg)
		return ct1==sg:GetCount()-g:GetCount() and ct1-ct2<=1
	end
end
function Auxiliary.FCheckMixRepFilter(c,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	if fun2(c,fc,sub,mg,sg) then
		g:AddCard(c)
		local sub=sub and fun2(c,fc,false,mg,sg)
		local res=Auxiliary.FCheckMixRep(sg,g,fc,sub,chkf,fun1,minc,maxc,...)
		g:RemoveCard(c)
		return res
	end
	return false
end
function Auxiliary.FCheckMixRepGoalCheck(tp,sg,fc,chkfnf)
	local concat_fusion=chkfnf&0x200>0
	if not concat_fusion and sg:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not Auxiliary.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	if Auxiliary.FGoalCheckAdditional and not Auxiliary.FGoalCheckAdditional(tp,sg,fc) then return false end
	return true
end
function Auxiliary.FCheckMixRepGoal(tp,sg,fc,sub,chkfnf,fun1,minc,maxc,...)
	local chkf=chkfnf&0xff
	if sg:GetCount()<minc+#{...} or sg:GetCount()>maxc+#{...} then return false end
	if not (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0) then return false end
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc) then return false end
	if not Auxiliary.FCheckMixRepGoalCheck(tp,sg,fc,chkfnf) then return false end
	local g=Group.CreateGroup()
	return Auxiliary.FCheckMixRep(sg,g,fc,sub,chkf,fun1,minc,maxc,...)
end
function Auxiliary.FCheckMixRepTemplate(c,cond,tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
	for i,f in ipairs({...}) do
		if f(c,fc,sub,mg,sg) then
			g:AddCard(c)
			local sub=sub and f(c,fc,false,mg,sg)
			local t={...}
			table.remove(t,i)
			local res=cond(tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,table.unpack(t))
			g:RemoveCard(c)
			if res then return true end
		end
	end
	if maxc>0 then
		if fun1(c,fc,sub,mg,sg) then
			g:AddCard(c)
			local sub=sub and fun1(c,fc,false,mg,sg)
			local res=cond(tp,mg,sg,g,fc,sub,chkfnf,fun1,minc-1,maxc-1,...)
			g:RemoveCard(c)
			if res then return true end
		end
	end
	return false
end
function Auxiliary.FCheckMixRepSelectedCond(tp,mg,sg,g,...)
	if g:GetCount()<sg:GetCount() then
		return sg:IsExists(Auxiliary.FCheckMixRepSelected,1,g,tp,mg,sg,g,...)
	else
		return Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,...)
	end
end
function Auxiliary.FCheckMixRepSelected(c,...)
	return Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckMixRepSelectedCond,...)
end
function Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
	local chkf=chkfnf&0xff
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,g,fc) then return false end
	if chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 then
		if minc<=0 and #{...}==0 and Auxiliary.FCheckMixRepGoalCheck(tp,g,fc,chkfnf) then return true end
		return mg:IsExists(Auxiliary.FCheckSelectMixRepAll,1,g,tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
	else
		return mg:IsExists(Auxiliary.FCheckSelectMixRepM,1,g,tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
	end
end
function Auxiliary.FCheckSelectMixRepAll(c,tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	if fun2 then
		if fun2(c,fc,sub,mg,sg) then
			g:AddCard(c)
			local sub=sub and fun2(c,fc,false,mg,sg)
			local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,...)
			g:RemoveCard(c)
			return res
		end
	elseif maxc>0 and fun1(c,fc,sub,mg,sg) then
		g:AddCard(c)
		local sub=sub and fun1(c,fc,false,mg,sg)
		local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,chkf,fun1,minc-1,maxc-1)
		g:RemoveCard(c)
		return res
	end
	return false
end
function Auxiliary.FCheckSelectMixRepM(c,tp,...)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckSelectMixRep,tp,...)
end
function Auxiliary.FSelectMixRep(c,tp,mg,sg,fc,sub,chkfnf,...)
	sg:AddCard(c)
	local res=false
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc) then
		res=false
	elseif Auxiliary.FCheckMixRepGoal(tp,sg,fc,sub,chkfnf,...) then
		res=true
	else
		local g=Group.CreateGroup()
		res=sg:IsExists(Auxiliary.FCheckMixRepSelected,1,nil,tp,mg,sg,g,fc,sub,chkfnf,...)
	end
	sg:RemoveCard(c)
	return res
end
--Fusion monster, name + name
function Auxiliary.AddFusionProcCode2(c,code1,code2,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2)
end
--Fusion monster, name + name + name
function Auxiliary.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3)
end
--Fusion monster, name + name + name + name
function Auxiliary.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3,code4)
end
--Fusion monster, name * n
function Auxiliary.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	local code={}
	for i=1,cc do
		code[i]=code1
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,table.unpack(code))
end
--Fusion monster, name * minc to maxc
function Auxiliary.AddFusionProcCodeRep2(c,code1,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,code1,minc,maxc)
end
--Fusion monster, name + condition * n
function Auxiliary.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,table.unpack(fun))
end
--Fusion monster, condition + condition
function Auxiliary.AddFusionProcFun2(c,f1,f2,insf)
	Auxiliary.AddFusionProcMix(c,false,insf,f1,f2)
end
--Fusion monster, condition * n
function Auxiliary.AddFusionProcFunRep(c,f,cc,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	Auxiliary.AddFusionProcMix(c,false,insf,table.unpack(fun))
end
--Fusion monster, condition * minc to maxc
function Auxiliary.AddFusionProcFunRep2(c,f,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f,minc,maxc)
end
--Fusion monster, condition1 + condition2 * n
function Auxiliary.AddFusionProcFunFun(c,f1,f2,cc,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f2
	end
	Auxiliary.AddFusionProcMix(c,false,insf,f1,table.unpack(fun))
end
--Fusion monster, condition1 + condition2 * minc to maxc
function Auxiliary.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f2,minc,maxc,f1)
end
--Fusion monster, name + condition * minc to maxc
function Auxiliary.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1)
end
--Fusion monster, name + name + condition * minc to maxc
function Auxiliary.AddFusionProcCode2FunRep(c,code1,code2,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1,code2)
end
--Fusion monster, Shaddoll materials
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
					and (mg:GetCount()==0 or (exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0)))) then
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

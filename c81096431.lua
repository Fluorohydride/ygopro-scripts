--ドレイク・シャーク
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--flag
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(id)
	e2:SetValue(id)
	e2:SetRange(0xff)
	e2:SetTarget(s.sxyzfilter)
	e2:SetCountLimit(1,id+o)
	c:RegisterEffect(e2)
	--material effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.xyzcon)
	e3:SetCost(s.xyzcost)
	e3:SetTarget(s.xyztg)
	e3:SetOperation(s.xyzop)
	c:RegisterEffect(e3)
end
function s.sxyzfilter(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function s.Drake_shark_f(function_f,int_lv,card_c)
	return function (c)
				return c:IsXyzLevel(card_c,int_lv) and (not function_f or function_f(c))
	end
end
function s.sxfilter(c,tp,xc)
	local te=c:IsHasEffect(id,tp)
	if te then
		local etg=te:GetTarget()
		return not etg or etg(te,xc)
	end
	return false
end
function s.sxvalue(c,tp,xc)
	local te=c:IsHasEffect(id,tp)
	if te then
		local etg=te:GetTarget()
		if not etg or etg(te,xc) then
			return te:GetValue()
		end
	end
end
function s.Drake_shark_gf(int_ct,int_tp,xc)
	return function (g)
				local ct=g:GetCount()
				local eg=g:Filter(s.sxfilter,nil,int_tp,xc)
				if #eg>0 then
					ct=ct+eg:GetClassCount(s.sxvalue,int_tp,xc)
				end
				local tc=g:GetFirst()
				while tc do
					local te=tc:IsHasEffect(EFFECT_XYZ_LEVEL,int_tp)
					if te then
						local evf=te:GetValue()
						if evf then
							local ev=evf(te,tc,xc)
							local lmct=(ev>>12)&0xf
							if lmct>0 and lmct>g:GetCount() then
								return false
							end
						end
					end
					tc=g:GetNext()
				end
				return ct>=int_ct
	end
end
function s.xfilter(c,tp)
	return c:IsHasEffect(id,tp)
end
function s.eftfilter(c,tp)
	local te=c:IsHasEffect(id,tp)
	return te:GetValue()
end
function s.gcheck(g,tp)
	return g:GetClassCount(s.eftfilter,tp)==g:GetCount()
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,81096431)==0 then
		Duel.RegisterFlagEffect(0,81096431,0,0,1)
		Drake_shark_AddXyzProcedure=aux.AddXyzProcedure
		function aux.AddXyzProcedure(card_c,function_f,int_lv,int_ct,function_alterf,int_dese,int_maxc,function_op)
			if int_ct>=3 then
				if function_alterf then
					Drake_shark_XyzLevelFreeOperationAlter=Auxiliary.XyzLevelFreeOperationAlter
					function Auxiliary.XyzLevelFreeOperationAlter(f,gf,minc,maxc,alterf,alterdesc,alterop)
						return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
									if og and not min then
										Auxiliary.Drake_Solve(tp,og,maxc,minc)
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
										Auxiliary.Drake_Solve(tp,mg,maxc,minc)
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
					aux.AddXyzProcedureLevelFree(card_c,s.Drake_shark_f(function_f,int_lv,card_c),s.Drake_shark_gf(int_ct,card_c:GetOwner(),card_c),int_ct-2,int_ct,function_alterf,int_dese,function_op)
					Auxiliary.XyzLevelFreeOperationAlter=Drake_shark_XyzLevelFreeOperationAlter
				else
					Drake_shark_XyzLevelFreeOperation=Auxiliary.XyzLevelFreeOperation
					function Auxiliary.XyzLevelFreeOperation(f,gf,minct,maxct)
						return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
									if og and not min then
										Auxiliary.Drake_Solve(tp,og,maxct,minct)
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
										Auxiliary.Drake_Solve(tp,mg,maxct,minct)
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
					aux.AddXyzProcedureLevelFree(card_c,s.Drake_shark_f(function_f,int_lv,card_c),s.Drake_shark_gf(int_ct,card_c:GetOwner(),card_c),int_ct-2,int_ct)
					Auxiliary.XyzLevelFreeOperation=Drake_shark_XyzLevelFreeOperation
				end
			else
				if function_alterf then
					Drake_shark_AddXyzProcedure(card_c,function_f,int_lv,int_ct,function_alterf,int_dese,int_maxc,function_op)
				else
					Drake_shark_AddXyzProcedure(card_c,function_f,int_lv,int_ct,nil,nil,int_maxc,nil)
				end
			end
		end
		local rg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil,TYPE_MONSTER)
		for tc in aux.Next(rg) do
			if tc.initial_effect then
				local Traitor_initial_effect=s.initial_effect
				s.initial_effect=function() end
				tc:ReplaceEffect(id,0)
				s.initial_effect=Traitor_initial_effect
				tc.initial_effect(tc)
			end
		end
	end
	e:Reset()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0x11b8) and c:IsType(TYPE_XYZ)
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanOverlay()
end
function s.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and s.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		tc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function Auxiliary.Drake_Solve(tp,g,maxct,minct,chkg)
	if g:GetCount()<maxct and g:GetCount()>=minct and maxct==minct+2 then
		local et=maxct-g:GetCount()
		local exg=g:Filter(Card.IsHasEffect,nil,81096431,tp)
		local ext=exg:GetClassCount(s.eftfilter,tp)
		if (et==0 or et==ext) and #exg>0 then
			for ttc in aux.Next(exg) do
				local tte=ttc:IsHasEffect(81096431,tp)
				if tte then
					Duel.Hint(HINT_CARD,0,ttc:GetCode())
					tte:UseCountLimit(tp)
				end
			end
		elseif #exg>0 then
			local st=et
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
			local reg=exg:SelectSubGroup(tp,s.gcheck,false,st,st,tp)
			for ttc in aux.Next(reg) do
				local tte=ttc:IsHasEffect(81096431,tp)
				if tte then
					Duel.Hint(HINT_CARD,0,ttc:GetCode())
					tte:UseCountLimit(tp)
				end
			end
		end
	end
end

--紋章獣グリフォン
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--flag
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(81096431)
	e2:SetValue(id)
	e2:SetRange(0xff)
	e2:SetTarget(s.sxyzfilter)
	e2:SetCountLimit(1,id+o)
	c:RegisterEffect(e2)
end
function s.costfilter(c)
	return c:IsSetCard(0x76) and c:IsType(TYPE_MONSTER) and not c:IsCode(id) and c:IsAbleToGraveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--material limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(0x7f,0x7f)
	e2:SetTarget(s.tlmtg)
	e2:SetValue(s.tlmval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--must material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(67120578)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and bit.band(sumtype,SUMMON_TYPE_XYZ)~=SUMMON_TYPE_XYZ
end
function s.tlmtg(e,c)
	return not c:IsOriginalSetCard(0x76,0x48)
end
function s.tlmval(e,c)
	if not c then return false end
	return c:GetControler()==e:GetOwnerPlayer()
end
function s.sxyzfilter(e,c)
	return c:IsSetCard(0x48)
end
function s.Drake_shark_f(function_f,int_lv,card_c)
	return function (c)
				return c:IsXyzLevel(card_c,int_lv) and (not function_f or function_f(c))
	end
end
function s.sxfilter(c,tp,xc)
	local te=c:IsHasEffect(81096431,tp)
	if te then
		local etg=te:GetTarget()
		return not etg or etg(te,xc)
	end
	return false
end
function s.sxvalue(c,tp,xc)
	local te=c:IsHasEffect(81096431,tp)
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
	return c:IsHasEffect(81096431,tp)
end
function s.eftfilter(c,tp)
	local te=c:IsHasEffect(81096431,tp)
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
function Auxiliary.Drake_Solve(tp,g,maxct,minct)
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

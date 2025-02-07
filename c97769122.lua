--バリアンズ・カオス・ドロー
function c97769122.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(c97769122.regcon)
	e1:SetOperation(c97769122.regop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97769122,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c97769122.condition)
	e2:SetCost(c97769122.cpcost)
	e2:SetTarget(c97769122.cptg)
	e2:SetOperation(c97769122.cpop)
	c:RegisterEffect(e2)
	--xyz summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97769122,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c97769122.condition)
	e3:SetTarget(c97769122.xyztg)
	e3:SetOperation(c97769122.xyzop)
	c:RegisterEffect(e3)
end
function c97769122.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,97769122)==0 and Duel.GetCurrentPhase()==PHASE_DRAW and c:IsReason(REASON_RULE)
end
function c97769122.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(97769122,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(97769122,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	end
end
function c97769122.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and e:GetHandler():GetFlagEffect(97769122)~=0
end
function c97769122.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c97769122.cpfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsSetCard(0x175) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c97769122.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c97769122.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c97769122.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c97769122.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c97769122.filter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97769122.filter2(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c97769122.fselect(sg,tp)
	local mg=Duel.GetMatchingGroup(c97769122.filter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(sg)
	return mg:CheckSubGroup(c97769122.matfilter,1,#mg,tp,sg)
end
function c97769122.matfilter(sg,tp,g)
	if sg:Filter(aux.IsInGroup,nil,g):GetCount()~=g:GetCount() then return false end
	return Duel.IsExistingMatchingCard(c97769122.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,sg)
end
function c97769122.xyzfilter(c,mg)
	return c:IsSetCard(0x48) and c:IsXyzSummonable(mg,#mg,#mg)
end
function c97769122.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c97769122.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and mg:CheckSubGroup(c97769122.fselect,1,ft,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c97769122.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) or ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local mg=Duel.GetMatchingGroup(c97769122.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=mg:SelectSubGroup(tp,c97769122.fselect,false,1,ft,tp)
	if not g then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.AdjustAll()
	if g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<#g then return end
	local exg=Duel.GetMatchingGroup(c97769122.xyzfilter2,tp,LOCATION_EXTRA,0,nil)
	local xyzg=exg:Filter(c97769122.ovfilter,nil,tp,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		local fg=Duel.GetMatchingGroup(c97769122.filter2,tp,LOCATION_MZONE,0,nil)
		local sg=fg:SelectSubGroup(tp,c97769122.gselect,false,1,7,xyz,g)
		Duel.XyzSummon(tp,xyz,sg)
	end
end
function c97769122.xyzfilter2(c)
	return c:IsSetCard(0x48)
end
function c97769122.ovfilter(c,tp,sg)
	local mg=Duel.GetMatchingGroup(c97769122.filter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(sg)
	return mg:CheckSubGroup(c97769122.gselect,1,#mg,c,sg)
end
function c97769122.gselect(sg,c,g)
	if sg:Filter(aux.IsInGroup,nil,g):GetCount()~=g:GetCount() then return false end
	return c:IsXyzSummonable(sg,#sg,#sg)
end

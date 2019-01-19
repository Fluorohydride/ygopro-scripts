--魔神儀の創造主－クリオルター
function c96915510.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,96915510)
	e1:SetCondition(c96915510.spcon)
	e1:SetCost(c96915510.spcost)
	e1:SetTarget(c96915510.sptg)
	e1:SetOperation(c96915510.spop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c96915510.atktg)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--attack
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
end
function c96915510.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c96915510.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c96915510.spfilter(c,e,tp)
	return c:IsSetCard(0x117) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c96915510.spcheck(g)
	return g:GetSum(Card.GetLevel)==10
end
function c96915510.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<1 then return false end
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.GetMatchingGroup(c96915510.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		return g:CheckSubGroup(c96915510.spcheck,1,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c96915510.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.GetMatchingGroup(c96915510.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c96915510.spcheck,false,1,ft)
		if sg then
			local c=e:GetHandler()
			local fid=c:GetFieldID()
			local tc=sg:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				tc:RegisterFlagEffect(96915510,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				tc=sg:GetNext()
			end
			Duel.SpecialSummonComplete()
			sg:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(sg)
			e1:SetCondition(c96915510.retcon)
			e1:SetOperation(c96915510.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c96915510.retfilter(c,fid)
	return c:GetFlagEffectLabel(96915510)==fid
end
function c96915510.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c96915510.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c96915510.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c96915510.retfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end
function c96915510.atktg(e,c)
	return c:IsSetCard(0x117) and not c:IsType(TYPE_RITUAL)
end

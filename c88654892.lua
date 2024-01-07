--突然回帰
function c88654892.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88654892+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(c88654892.cost)
	e1:SetTarget(c88654892.target)
	e1:SetOperation(c88654892.activate)
	c:RegisterEffect(e1)
end
function c88654892.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c88654892.filter1(c,e,tp,ft)
	local lv=c:GetLevel()
	return lv>0 and c:IsReleasable() and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO)) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c88654892.filter2,tp,LOCATION_DECK,0,1,nil,lv,e,tp)
end
function c88654892.filter2(c,lv,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88654892.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return ft>-1 and Duel.CheckReleaseGroup(REASON_COST,tp,c88654892.filter1,1,nil,e,tp,ft)
	end
	local rg=Duel.SelectReleaseGroup(REASON_COST,tp,c88654892.filter1,1,1,nil,e,tp,ft)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c88654892.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c88654892.filter2,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(88654892,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c88654892.thcon)
		e1:SetOperation(c88654892.thop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c88654892.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(88654892)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c88654892.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end

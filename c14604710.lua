--星遺物の胎導
function c14604710.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14604710+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c14604710.target)
	e1:SetOperation(c14604710.activate)
	c:RegisterEffect(e1)
end
function c14604710.spfilter1(c,e,tp)
	return c:IsLevel(9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14604710.tgfilter2(c,e,tp)
	if c:IsFacedown() or not c:IsLevel(9) then return false end
	local g=Duel.GetMatchingGroup(c14604710.spfilter2,tp,LOCATION_DECK,0,nil,e,tp,c)
	return g:GetClassCount(Card.GetCode)>1
end
function c14604710.spfilter2(c,e,tp,tc)
	return c:IsLevel(9) and c:GetOriginalRace()~=tc:GetOriginalRace() and c:GetOriginalAttribute()~=tc:GetOriginalAttribute()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14604710.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()~=1 then return false end
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14604710.tgfilter2(chkc,e,tp) end
	end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14604710.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c14604710.tgfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(14604710,0),aux.Stringid(14604710,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(14604710,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(14604710,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c14604710.tgfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
	end
end
function c14604710.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c14604710.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local g=Duel.GetMatchingGroup(c14604710.spfilter2,tp,LOCATION_DECK,0,nil,e,tp,tc)
		if not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and ft>1 and g:GetClassCount(Card.GetCode)>1 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			local fid=c:GetFieldID()
			local sc=g1:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_ATTACK)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
				sc:RegisterFlagEffect(14604710,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				sc=g1:GetNext()
			end
			g1:KeepAlive()
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCountLimit(1)
			e2:SetLabel(fid)
			e2:SetLabelObject(g1)
			e2:SetCondition(c14604710.descon)
			e2:SetOperation(c14604710.desop)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c14604710.desfilter(c,fid)
	return c:GetFlagEffectLabel(14604710)==fid
end
function c14604710.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c14604710.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c14604710.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c14604710.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end

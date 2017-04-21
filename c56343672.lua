--レスキューフェレット
function c56343672.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(56343672,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c56343672.spcost)
	e1:SetTarget(c56343672.sptg)
	e1:SetOperation(c56343672.spop)
	c:RegisterEffect(e1)
end
function c56343672.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c56343672.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c56343672.spfilter(c,e,tp,zone)
	return c:GetLevel()>0 and not c:IsCode(56343672) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c56343672.spfilter0(c,e,tp)
	return c:GetLevel()>0 and not c:IsCode(56343672) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c56343672.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=bit.band(Duel.GetLinkedZone(tp),0x1f)
		if zone==0 then return false end
		local tempfix=false
		local ct=0
		for i=0,4 do
			local z=bit.lshift(1,i)
			local c=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
			if bit.band(zone,z)>0 then
				if not c then
					ct=ct+1
				elseif c==e:GetHandler() then
					tempfix=true
					ct=ct+1
				end
			end
		end
		if ct==0 then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		if not tempfix then
			local g=Duel.GetMatchingGroup(c56343672.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone)
			return g:CheckWithSumEqual(Card.GetLevel,6,1,ct)
		else
			local g=Duel.GetMatchingGroup(c56343672.spfilter0,tp,LOCATION_DECK,0,nil,e,tp)
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and g:CheckWithSumEqual(Card.GetLevel,6,1,ct)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c56343672.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=bit.band(Duel.GetLinkedZone(tp),0x1f)
	if zone==0 then return end
	local ct=0
	for i=0,4 do
		local z=bit.lshift(1,i)
		if bit.band(zone,z)>0 and Duel.CheckLocation(tp,LOCATION_MZONE,i) then
			ct=ct+1
		end
	end
	if ct==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local g=Duel.GetMatchingGroup(c56343672.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone)
	if ct>0 and g:CheckWithSumEqual(Card.GetLevel,6,1,ct) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectWithSumEqual(tp,Card.GetLevel,6,1,ct)
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(56343672,RESET_EVENT+0x1fe0000,0,1,fid)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(sg)
		e3:SetCondition(c56343672.descon)
		e3:SetOperation(c56343672.desop)
		Duel.RegisterEffect(e3,tp)
	end
end
function c56343672.desfilter(c,fid)
	return c:GetFlagEffectLabel(56343672)==fid
end
function c56343672.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c56343672.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c56343672.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c56343672.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end

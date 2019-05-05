--エレメントセイバー・ウィラード
function c71797713.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71797713,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71797713)
	e1:SetCost(c71797713.spcost)
	e1:SetTarget(c71797713.sptg)
	e1:SetOperation(c71797713.spop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c71797713.regcon)
	e2:SetOperation(c71797713.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
end
function c71797713.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and (c:IsSetCard(0x400d) or c:IsLocation(LOCATION_HAND))
end
function c71797713.regfilter(c,attr)
	return c:IsSetCard(0x400d) and bit.band(c:GetOriginalAttribute(),attr)~=0
end
function c71797713.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,61557074)}) do
		fg:AddCard(pe:GetHandler())
	end
	local loc=LOCATION_HAND
	if fg:GetCount()>0 then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c71797713.costfilter,tp,loc,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71797713.costfilter,tp,loc,0,2,2,e:GetHandler())
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		local fc=nil
		if fg:GetCount()==1 then
			fc=fg:GetFirst()
		else
			fc=fg:Select(tp,1,1,nil)
		end
		Duel.Hint(HINT_CARD,0,fc:GetCode())
		fc:RegisterFlagEffect(61557074,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
	local flag=0
	if g:IsExists(c71797713.regfilter,1,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WIND) then flag=bit.bor(flag,0x1) end
	if g:IsExists(c71797713.regfilter,1,nil,ATTRIBUTE_WATER+ATTRIBUTE_FIRE) then flag=bit.bor(flag,0x2) end
	if g:IsExists(c71797713.regfilter,1,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) then flag=bit.bor(flag,0x4) end
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(flag)
end
function c71797713.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71797713.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
function c71797713.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1 and e:GetLabelObject():GetLabel()~=0
end
function c71797713.regop(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c71797713.immtg)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	if bit.band(flag,0x1)~=0 then
		local e1=e0:Clone()
		e1:SetDescription(aux.Stringid(71797713,1))
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
	if bit.band(flag,0x2)~=0 then
		local e2=e0:Clone()
		e2:SetDescription(aux.Stringid(71797713,2))
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetValue(1)
		c:RegisterEffect(e2)
	end
	if bit.band(flag,0x4)~=0 then
		local e3=e0:Clone()
		e3:SetDescription(aux.Stringid(71797713,3))
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetValue(aux.tgoval)
		c:RegisterEffect(e3)
	end
end
function c71797713.immtg(e,c)
	return c:IsSetCard(0x400d,0x113)
end

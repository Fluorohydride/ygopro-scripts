--マシュマオ☆ヤミー
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(s.checkop)
	c:RegisterEffect(e4)
end
function s.cfilter(c)
	return c:IsFacedown() or not (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_BEAST))
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x1ca) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.pfilter(c,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x1ca)
		and (c:IsType(TYPE_CONTINUOUS) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		or c:IsType(TYPE_FIELD))
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		or Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,tp)
		and e:GetHandler():GetFlagEffect(id)>0 end
	if e:GetHandler():GetFlagEffect(id)>0 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,nil)
	local b2=e:GetLabel()==1 and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,tp)
	if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
		if tc then
			if tc:IsType(TYPE_CONTINUOUS) then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			end
		end
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_SYNCHRO) then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_TEMP_REMOVE,0,1)
	end
end

--ダークリボー
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,24094653)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.indcon1)
	e1:SetCost(s.indcost)
	e1:SetTarget(s.indtg1)
	e1:SetOperation(s.indop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(s.indcon2)
	e2:SetTarget(s.indtg2)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.cfilter(c,tp)
	return c:IsFaceupEx() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and (c:IsRace(RACE_FIEND) or c:IsAllTypes(TYPE_FUSION+TYPE_MONSTER))
end
function s.indcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.indcon2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and s.cfilter(d,tp)
end
function s.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.indfilter(c,g,tp)
	return g:IsContains(c) and s.cfilter(c,tp)
end
function s.indtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.indfilter(chkc,eg,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.indfilter,tp,LOCATION_MZONE,0,1,nil,eg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.indfilter,tp,LOCATION_MZONE,0,1,1,nil,eg,tp)
end
function s.indtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttackTarget()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function s.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		tc:RegisterFlagEffect(id,RESET_EVENT+RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_DISEFFECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
		e3:SetValue(s.effectfilter)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.effectfilter(e,ct)
	local te,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
	local tc=e:GetLabelObject()
	return tc and tc==te:GetHandler() and bit.band(loc,LOCATION_MZONE)~=0
		and tc:GetFlagEffect(id)~=0
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and bit.band(r,REASON_EFFECT)~=0
end
function s.thfilter(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

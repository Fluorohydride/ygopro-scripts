--急雷の泥沼
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to hand
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,{EVENT_TO_GRAVE,EVENT_REMOVE})
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(custom_code)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.setfilter(c)
	return c:IsAllTypes(TYPE_CONTINUOUS+TYPE_TRAP) and c:IsSSetable()
		and (c:GetOriginalLevel()>0
		or bit.band(c:GetOriginalRace(),0x3fffffff)~=0
		or bit.band(c:GetOriginalAttribute(),0x7f)~=0
		or c:GetBaseAttack()>0
		or c:GetBaseDefense()>0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local dg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,REASON_EFFECT+REASON_DISCARD)
	if g:GetCount()>0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		local tg=Duel.GetOperatedGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,tg)
		Duel.SSet(tp,sg)
	end
end
function s.thfilter(c,e,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsFaceupEx()
		and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function s.thfilter2(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:FilterCount(s.thfilter,nil,e,tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg
	if #eg==1 then
		tg=eg:Clone()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tg=eg:FilterSelect(tp,s.thfilter,1,1,nil,e,tp)
	end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

--帝王の策略
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,4929256,9748752,26205777,51945556,60229110,73125233)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(id) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.thfilter(c,att)
	return c:IsAttack(2400) and c:IsDefense(1000) and c:IsAttribute(att)
		and c:IsAbleToHand()
end
function s.tgfilter(c,tp)
	local att=c:GetAttribute()
	return c:IsFaceup() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,att)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.tgfilter(chkc,tp) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsCode(4929256,9748752,26205777,51945556,60229110,73125233)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToChain() or not tc:IsType(TYPE_MONSTER) or not tc:IsFaceup() then return end
	local att=tc:GetAttribute()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,att)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local sumg=Duel.GetMatchingGroup(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		if sumg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sc=sumg:Select(tp,1,1,nil):GetFirst()
			if sc then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.Summon(tp,sc,true,nil)
			end
		end
	end
end

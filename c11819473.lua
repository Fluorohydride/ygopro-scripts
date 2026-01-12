--アルカナリーディング
function c11819473.initial_effect(c)
	aux.AddCodeList(c,73206827)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11819473,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11819473)
	e1:SetTarget(c11819473.target)
	e1:SetOperation(c11819473.activate)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11819473,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11819474)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c11819473.sumtg)
	e2:SetOperation(c11819473.sumop)
	c:RegisterEffect(e2)
end
function c11819473.thfilter1(c)
	return not c:IsCode(11819473) and c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_COIN)) and c:IsAbleToHand()
end
function c11819473.thfilter2(c,p)
	return c:IsAbleToHand(p)
end
function c11819473.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11819473.thfilter1,tp,LOCATION_DECK,0,1,nil)
		or Duel.IsExistingMatchingCard(c11819473.thfilter2,tp,0,LOCATION_DECK,1,nil,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function c11819473.activate(e,tp,eg,ep,ev,re,r,rp)
	local res
	if Duel.IsEnvironment(73206827,tp,LOCATION_FZONE) then
		local off=1
		local ops={}
		local opval={}
		if Duel.IsExistingMatchingCard(c11819473.thfilter1,tp,LOCATION_DECK,0,1,nil) then
			ops[off]=aux.Stringid(11819473,2)
			opval[off-1]=0
			off=off+1
		end
		if Duel.IsExistingMatchingCard(c11819473.thfilter2,tp,0,LOCATION_DECK,1,nil,1-tp) then
			ops[off]=aux.Stringid(11819473,3)
			opval[off-1]=1
			off=off+1
		end
		if off==1 then return end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		res=opval[op]
	else
		res=1-Duel.TossCoin(tp,1)
	end
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c11819473.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,c11819473.thfilter2,1-tp,LOCATION_DECK,0,1,1,nil,1-tp)
		if g:GetCount()>0 then
			g:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function c11819473.sumfilter(c)
	return c:IsSetCard(0x5) and c:IsSummonable(true,nil)
end
function c11819473.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11819473.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c11819473.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c11819473.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end

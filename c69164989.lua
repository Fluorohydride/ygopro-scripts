--六花絢爛
function c69164989.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,69164989+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c69164989.cost)
	e1:SetTarget(c69164989.target)
	e1:SetOperation(c69164989.activate)
	c:RegisterEffect(e1)
end
function c69164989.costfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup())
		and (c:IsRace(RACE_PLANT) or c:IsHasEffect(76869711,tp) and c:IsControler(1-tp))
end
function c69164989.thfilter(c,tp,check)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x141) and c:IsAbleToHand()
		and (check or Duel.IsExistingMatchingCard(c69164989.thfilter2,tp,LOCATION_DECK,0,1,c,c:GetCode(),c:GetOriginalLevel()))
end
function c69164989.thfilter2(c,code,lv)
	return c:IsRace(RACE_PLANT) and not c:IsCode(code) and c:GetOriginalLevel()==lv and c:IsAbleToHand()
end
function c69164989.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckReleaseGroup(REASON_COST,tp,c69164989.costfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c69164989.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(69164989,0)) then
		local g=Duel.SelectReleaseGroup(REASON_COST,tp,c69164989.costfilter,1,1,nil,e,tp)
		Duel.Release(g,REASON_COST)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c69164989.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69164989.thfilter,tp,LOCATION_DECK,0,1,nil,tp,true) end
	local ct=1
	if e:GetLabel()==1 then ct=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
end
function c69164989.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c69164989.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()==0 then
		g=Duel.SelectMatchingCard(tp,c69164989.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp,true)
	end
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		if e:GetLabel()==1 and tc:IsLocation(LOCATION_HAND)
			and Duel.IsExistingMatchingCard(c69164989.thfilter2,tp,LOCATION_DECK,0,1,nil,tc:GetCode(),tc:GetOriginalLevel()) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,c69164989.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),tc:GetOriginalLevel())
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end

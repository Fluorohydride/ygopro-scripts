--インフェルニティ・パラノイア
---@param c Card
function c86547356.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86547356,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,86547356+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c86547356.cost)
	e1:SetTarget(c86547356.target)
	e1:SetOperation(c86547356.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86547356,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c86547356.thtg)
	e2:SetOperation(c86547356.thop)
	c:RegisterEffect(e2)
end
function c86547356.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0,0)
	return true
end
function c86547356.costfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelAbove(1) and Duel.GetMZoneCount(tp,c)>0 and (c:IsFaceup() or c:IsControler(tp))
		and Duel.IsExistingMatchingCard(c86547356.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode(),c:GetLevel())
end
function c86547356.spfilter(c,e,tp,code,lv)
	return c:IsSetCard(0xb) and not c:IsCode(code) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c86547356.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check,code,lv=e:GetLabel()
	if chk==0 then
		if check~=100 then return false end
		e:SetLabel(0,0,0)
		return Duel.CheckReleaseGroup(tp,c86547356.costfilter,1,nil,e,tp)
	end
	local tc=Duel.SelectReleaseGroup(tp,c86547356.costfilter,1,1,nil,e,tp):GetFirst()
	e:SetLabel(0,tc:GetCode(),tc:GetLevel())
	Duel.Release(tc,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c86547356.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check,code,lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c86547356.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,code,lv)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c86547356.thfilter(c)
	return c:IsSetCard(0xb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c86547356.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c86547356.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c86547356.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c86547356.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c86547356.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--死の宣告
---@param c Card
function c40771118.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40771118,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,40771118)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c40771118.thtg)
	e2:SetOperation(c40771118.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40771118,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,40771118)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCost(c40771118.plcost)
	e3:SetTarget(c40771118.pltg)
	e3:SetOperation(c40771118.plop)
	c:RegisterEffect(e3)
end
function c40771118.thfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_FIEND) and c:IsAbleToHand()
end
function c40771118.cfilter(c)
	return c:IsFaceup() and (c:IsCode(94212438) or c:IsSetCard(0x1c))
end
function c40771118.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c40771118.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40771118.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local cg=Duel.GetMatchingGroup(c40771118.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=cg:GetClassCount(Card.GetCode)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c40771118.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c40771118.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c40771118.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsStatus(STATUS_EFFECT_ENABLED) end
	Duel.SendtoGrave(c,REASON_COST)
end
function c40771118.plfilter(c,tp,mc)
	if not c:IsSetCard(0x1c) then return false end
	if Duel.IsPlayerAffectedByEffect(tp,16625614) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp,SUMMON_VALUE_DARK_SANCTUARY) then return true end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if mc:IsLocation(LOCATION_SZONE) then ft=ft+1 end
	return ft>0 and not c:IsForbidden()
end
function c40771118.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40771118.plfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp,e:GetHandler()) end
end
function c40771118.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40771118,2))
	local g=Duel.SelectMatchingCard(tp,c40771118.plfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp,c)
	local tc=g:GetFirst()
	if tc and Duel.IsPlayerAffectedByEffect(tp,16625614) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp,SUMMON_VALUE_DARK_SANCTUARY)
		and Duel.SelectYesNo(tp,aux.Stringid(16625614,0)) then
		tc:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_DARK,RACE_FIEND,1,0,0)
		Duel.SpecialSummonStep(tc,SUMMON_VALUE_DARK_SANCTUARY,tp,tp,true,false,POS_FACEUP)
		--immune
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c16625614.efilter)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e1)
		--cannot be target
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	elseif tc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

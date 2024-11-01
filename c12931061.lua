--U.A.ハイパー・スタジアム
---@param c Card
function c12931061.initial_effect(c)
	aux.AddCodeList(c,19814508)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,12931061+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12931061.target)
	e1:SetOperation(c12931061.activate)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12931061,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c12931061.excost)
	e2:SetTarget(c12931061.extg)
	e2:SetOperation(c12931061.exop)
	c:RegisterEffect(e2)
end
function c12931061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c12931061.thfilter(c)
	if not c:IsAbleToHand() then return false end
	return c:IsLocation(LOCATION_DECK) and c:IsSetCard(0xb2,0x107) and c:IsType(TYPE_MONSTER)
		or c:IsLocation(LOCATION_GRAVE) and c:IsCode(19814508)
end
function c12931061.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c12931061.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local sel=1
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12931061,0))
	if g:GetCount()>0 then
		sel=Duel.SelectOption(tp,1213,1214)
	else
		sel=Duel.SelectOption(tp,1214)+1
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c12931061.cfilter(c)
	return c:IsType(TYPE_FIELD) and not c:IsPublic()
end
function c12931061.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12931061.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.CheckLPCost(tp,1000)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c12931061.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.PayLPCost(tp,1000)
end
function c12931061.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,12931061)==0
		and Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
end
function c12931061.exop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(12931061,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(c12931061.estg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,12931061,RESET_PHASE+PHASE_END,0,1)
end
function c12931061.estg(e,c)
	return c:IsSetCard(0xb2,0x107)
end

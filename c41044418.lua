--千年の啓示
function c41044418.initial_effect(c)
	aux.AddCodeList(c,10000010)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41044418,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,41044418)
	e1:SetCost(c41044418.thcost)
	e1:SetTarget(c41044418.thtg)
	e1:SetOperation(c41044418.thop)
	c:RegisterEffect(e1)
	--Reborn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41044418,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,41044419)
	e2:SetCondition(c41044418.rbcon)
	e2:SetCost(c41044418.rbcost)
	e2:SetTarget(c41044418.rbtg)
	e2:SetOperation(c41044418.rbop)
	c:RegisterEffect(e2)
end
function c41044418.costfilter(c)
	return c:IsRace(RACE_DIVINE) and c:IsAbleToGraveAsCost()
end
function c41044418.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c41044418.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c41044418.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c41044418.thfilter(c)
	return c:IsCode(83764718) and c:IsAbleToHand()
end
function c41044418.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c41044418.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c41044418.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c41044418.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c41044418.rbcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c41044418.rbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c41044418.rbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,41044418)==0 end
end
function c41044418.rbop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,41044418)~=0 then return end
	local c=e:GetHandler()
	--rebirth
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(41044418)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--reg
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetCondition(c41044418.regcon)
	e0:SetOperation(c41044418.regop)
	Duel.RegisterEffect(e0,tp)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c41044418.tgcon)
	e2:SetOperation(c41044418.tgop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,41044418,RESET_PHASE+PHASE_END,0,1)
end
function c41044418.regfilter(c)
	local code,code2=c:GetSpecialSummonInfo(SUMMON_INFO_CODE,SUMMON_INFO_CODE2)
	return c:IsCode(10000010) and (c:GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_MONSTER_REBORN or code==83764718 or code2==83764718)
end
function c41044418.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c41044418.regfilter,1,nil)
end
function c41044418.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c41044418.regfilter,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(41044418,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c41044418.tgfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(41044418)~=0
end
function c41044418.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c41044418.tgfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c41044418.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c41044418.tgfilter,tp,LOCATION_MZONE,0,nil)
	Duel.HintSelection(g)
	Duel.SendtoGrave(g,REASON_RULE)
end

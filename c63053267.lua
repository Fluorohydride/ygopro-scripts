--ナーゲルの守護天
---@param c Card
function c63053267.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c63053267.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--double damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c63053267.damcon)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x10b))
	e4:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,63053267)
	e5:SetCost(c63053267.thcost)
	e5:SetTarget(c63053267.thtg)
	e5:SetOperation(c63053267.thop)
	c:RegisterEffect(e5)
	--reg
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c63053267.regcon)
	e6:SetOperation(c63053267.regop)
	c:RegisterEffect(e6)
end
function c63053267.indtg(e,c)
	return c:IsSetCard(0x10b) and c:GetSequence()<5
end
function c63053267.regcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and eg:GetFirst():IsSetCard(0x10b)
end
function c63053267.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(63053267,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c63053267.damcon(e)
	return e:GetHandler():GetFlagEffect(63053267)==0
end
function c63053267.cfilter(c)
	return c:IsSetCard(0x10b) and c:IsDiscardable()
end
function c63053267.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c63053267.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c63053267.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c63053267.filter(c)
	return c:IsCode(63053267) and c:IsAbleToHand()
end
function c63053267.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c63053267.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c63053267.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c63053267.filter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--双天将 金剛
---@param c Card
function c33026283.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,85360035,aux.FilterBoolFunction(Card.IsFusionSetCard,0x14f),2,true,true)
	--effect monster material check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c33026283.matcheck)
	c:RegisterEffect(e0)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c33026283.actcon)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33026283,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c33026283.thcon)
	e2:SetTarget(c33026283.thtg)
	e2:SetOperation(c33026283.thop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33026283,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33026283)
	e3:SetCondition(c33026283.discon)
	e3:SetTarget(c33026283.distg)
	e3:SetOperation(c33026283.disop)
	c:RegisterEffect(e3)
end
function c33026283.matcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_EFFECT) then
		c:RegisterFlagEffect(85360035,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
	end
end
function c33026283.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c33026283.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function c33026283.thfilter(c)
	return c:IsAbleToHand() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c33026283.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c33026283.thfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33026283.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c33026283.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c33026283.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c33026283.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c33026283.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c33026283.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c33026283.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end

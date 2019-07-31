--アドバンスド・ダーク
function c12644061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetCondition(c12644061.condition)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1034))
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c12644061.discon)
	e3:SetOperation(c12644061.disop)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(c12644061.distg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12644061,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c12644061.damcon)
	e4:SetCost(c12644061.damcost)
	e4:SetOperation(c12644061.damop)
	c:RegisterEffect(e4)
	--12644061 chk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(12644061)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetCondition(c12644061.condition)
	c:RegisterEffect(e5)
end
function c12644061.discon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return at and a:IsSetCard(0x2034)
end
function c12644061.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	tc:RegisterFlagEffect(12644061,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c12644061.distg(e,c)
	return c:GetFlagEffect(12644061)~=0
end
function c12644061.condition(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) 
		and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY)
end
function c12644061.damcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return Duel.GetBattleDamage(tp)>0
		and ((a:IsControler(tp) and a:IsSetCard(0x1034)) or (at and at:IsControler(tp) and at:IsSetCard(0x1034)))
end
function c12644061.dfilter(c)
	return c:IsSetCard(0x1034) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c12644061.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12644061.dfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12644061.dfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c12644061.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(c12644061.dop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end
function c12644061.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end

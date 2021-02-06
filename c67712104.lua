--海晶乙女クリスタルハート
function c67712104.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WATER),2,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c67712104.immcon1)
	e1:SetValue(c67712104.efilter1)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c67712104.immcon2)
	e2:SetTarget(c67712104.immtg2)
	e2:SetValue(c67712104.efilter2)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67712104,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c67712104.indcon)
	e3:SetCost(c67712104.indcost)
	e3:SetTarget(c67712104.indtg)
	e3:SetOperation(c67712104.indop)
	c:RegisterEffect(e3)
	--global chk of 91027843
	if not c67712104.global_check then
		c67712104.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(c67712104.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c67712104.valcheck(e,c)
	local g=c:GetMaterial()
	if c:IsType(TYPE_LINK) and g:IsExists(Card.IsLinkCode,1,nil,67712104) then
		c:RegisterFlagEffect(91027843,RESET_EVENT+0x4fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(91027843,0))
	end
end
function c67712104.immcon1(e)
	return e:GetHandler():GetSequence()>4
end
function c67712104.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c67712104.immcon2(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and e:GetHandler():GetBattleTarget()
end
function c67712104.immtg2(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c67712104.efilter2(e,te,c)
	return c~=te:GetOwner()
end
function c67712104.indcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	if not at then return false end
	local c=e:GetHandler()
	if at==c then return true end
	local lg=c:GetLinkedGroup()
	return at and at:IsControler(tp) and at:IsFaceup() and at:IsSetCard(0x12b) and lg:IsContains(at)
end
function c67712104.costfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c67712104.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67712104.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c67712104.costfilter,1,1,REASON_COST)
end
function c67712104.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.GetAttackTarget():CreateEffectRelation(e)
end
function c67712104.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttackTarget()
	if at:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		at:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end

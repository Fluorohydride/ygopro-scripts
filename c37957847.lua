--インセクト・プリンセス
---@param c Card
function c37957847.initial_effect(c)
	--Pos Change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c37957847.target)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c37957847.atkcon)
	e2:SetOperation(c37957847.atkop)
	c:RegisterEffect(e2)
end
function c37957847.target(e,c)
	return c:IsRace(RACE_INSECT)
end
function c37957847.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsRace(RACE_INSECT)
end
function c37957847.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

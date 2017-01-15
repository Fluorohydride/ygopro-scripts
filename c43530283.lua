--勇気の砂時計
function c43530283.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43530283,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c43530283.adop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c43530283.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(c43530283.atkval)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(c43530283.defval)
		c:RegisterEffect(e2)
		if Duel.GetTurnPlayer()==tp then
			c:RegisterFlagEffect(43530283,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		else
			c:RegisterFlagEffect(43530283,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
		end
	end
end
function c43530283.atkval(e,c)
	if c:GetFlagEffect(43530283)==0 then
		return c:GetBaseAttack()*2
	else
		return c:GetBaseAttack()/2
	end
end
function c43530283.defval(e,c)
	if c:GetFlagEffect(43530283)==0 then
		return c:GetBaseDefense()*2
	else
		return c:GetBaseDefense()/2
	end
end

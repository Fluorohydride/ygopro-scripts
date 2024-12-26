--飛行エレファント
---@param c Card
function c66765023.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetCondition(c66765023.indcon)
	e1:SetValue(c66765023.valcon)
	c:RegisterEffect(e1)
	--add win effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c66765023.effcon)
	e2:SetOperation(c66765023.effop)
	c:RegisterEffect(e2)
end
function c66765023.indcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c66765023.valcon(e,re,r,rp)
	local res=false
	if bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandlerPlayer() then
		res=true
		e:GetHandler():RegisterFlagEffect(66765023,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	return res
end
function c66765023.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(66765023)~=0 and Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c66765023.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66765023,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c66765023.wincon)
	e1:SetOperation(c66765023.winop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
end
function c66765023.wincon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c66765023.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_FLYING_ELEPHANT=0x1e
	Duel.Win(tp,WIN_REASON_FLYING_ELEPHANT)
end

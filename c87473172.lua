--火炎鳥
---@param c Card
function c87473172.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87473172,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c87473172.atkcon)
	e1:SetOperation(c87473172.atkop)
	c:RegisterEffect(e1)
end
function c87473172.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and bit.band(c:GetPreviousRaceOnField(),RACE_WINDBEAST)~=0
end
function c87473172.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c87473172.cfilter,1,nil,tp)
end
function c87473172.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		c:RegisterEffect(e1)
	end
end

--破邪の魔法壁
function c81231742.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c81231742.atkcon)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(c81231742.defcon)
	c:RegisterEffect(e3)
end
function c81231742.atkcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c81231742.defcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end

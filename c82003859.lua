--通行税
function c82003859.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c82003859.atcon)
	e2:SetCost(c82003859.atcost)
	e2:SetOperation(c82003859.atop)
	c:RegisterEffect(e2)
	--accumulate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(82003859)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	c:RegisterEffect(e3)
end
function c82003859.filter(c,fid)
	return c:IsHasEffect(82003859) and c:GetFieldID()<fid
end
function c82003859.atcon(e)
	return not Duel.IsExistingMatchingCard(c82003859.filter,0,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler():GetFieldID())
end
function c82003859.atcost(e,c,tp)
	local ct=Duel.GetMatchingGroupCount(Card.IsHasEffect,0,LOCATION_SZONE,LOCATION_SZONE,nil,82003859)
	return Duel.CheckLPCost(tp,ct*500)
end
function c82003859.atop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsHasEffect,0,LOCATION_SZONE,LOCATION_SZONE,nil,82003859)
	Duel.PayLPCost(tp,ct*500)
end

--端末世界NEXT
function c48605591.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c48605591.condition)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_MAX_MZONE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c48605591.mvalue)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_MAX_SZONE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(c48605591.svalue)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(c48605591.aclimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_SSET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c48605591.setlimit)
	c:RegisterEffect(e5)
end
function c48605591.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)<=3
		and Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)<=3
end
function c48605591.mvalue(e,fp,rp,r)
	if r~=LOCATION_REASON_TOFIELD then return 5 end
	return 3
end
function c48605591.svalue(e,fp,rp,r)
	if r~=LOCATION_REASON_TOFIELD then return 5 end
	local ct=3
	for i=5,7 do
		if Duel.GetFieldCard(fp,LOCATION_SZONE,i) then ct=ct-1 end
	end
	return ct
end
function c48605591.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	if re:IsActiveType(TYPE_FIELD) then
		return not Duel.GetFieldCard(tp,LOCATION_SZONE,5) and Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)>2
	elseif re:IsActiveType(TYPE_PENDULUM) then
		return Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)>2
	end
	return false
end
function c48605591.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD) and not Duel.GetFieldCard(tp,LOCATION_SZONE,5) and Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)>2
end

--天威無崩の地
---@param c Card
function c39730727.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--immune effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c39730727.etarget)
	e2:SetValue(c39730727.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_ACTIVATE_CONDITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c39730727.drcon)
	e3:SetTarget(c39730727.drtg)
	e3:SetOperation(c39730727.drop)
	c:RegisterEffect(e3)
end
function c39730727.etarget(e,c)
	return not c:IsType(TYPE_EFFECT)
end
function c39730727.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER)
end
function c39730727.drfilter1(c)
	return (not c:IsType(TYPE_EFFECT) and c:IsFaceup()) or c:IsFacedown()
end
function c39730727.drfilter2(c,tp)
	return c:IsType(TYPE_EFFECT) and c:IsSummonPlayer(1-tp) and c:IsFaceup()
end
function c39730727.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c39730727.drfilter1,tp,LOCATION_MZONE,0,1,nil)
		and eg:IsExists(c39730727.drfilter2,1,nil,tp)
end
function c39730727.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c39730727.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

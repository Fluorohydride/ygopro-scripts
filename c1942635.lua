--王の報酬
function c1942635.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c1942635.atkcon)
	e2:SetValue(c1942635.atkval)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1942635,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,1942635)
	e3:SetCondition(c1942635.drcon)
	e3:SetTarget(c1942635.drtg)
	e3:SetOperation(c1942635.drop)
	c:RegisterEffect(e3)
end
function c1942635.atkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function c1942635.atkval(e,c)
	return c:IsFaceup() and c:IsSetCard(0x134) and c:IsType(TYPE_EFFECT)
end
function c1942635.cfilter(c)
	return bit.band(c:GetPreviousTypeOnField(),TYPE_EFFECT)~=0 and c:IsPreviousSetCard(0x134)
end
function c1942635.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1942635.cfilter,1,nil)
end
function c1942635.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c1942635.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

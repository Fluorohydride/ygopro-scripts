--トリックスター・ディーヴァリディス
function c14365823.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,14365823)
	aux.AddLinkProcedure(c,c14365823.mfilter,2,2)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14365823,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c14365823.damtg)
	e1:SetOperation(c14365823.damop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14365823,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c14365823.damcon2)
	e2:SetTarget(c14365823.damtg)
	e2:SetOperation(c14365823.damop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c14365823.mfilter(c)
	return c:IsLinkSetCard(0xfb) and c:IsLevelBelow(3)
end
function c14365823.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c14365823.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c14365823.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c14365823.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c14365823.cfilter,1,nil,1-tp)
end

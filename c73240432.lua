--エッジインプ・コットン・イーター
function c73240432.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FUSION))
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73240432,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c73240432.drcon)
	e2:SetTarget(c73240432.drtg)
	e2:SetOperation(c73240432.drop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(73240432,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,73240432)
	e3:SetTarget(c73240432.damtg)
	e3:SetOperation(c73240432.damop)
	c:RegisterEffect(e3)
end
function c73240432.cfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xad) and c:IsType(TYPE_FUSION)
		and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c73240432.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c73240432.cfilter,1,nil,tp)
end
function c73240432.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c73240432.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c73240432.damfilter(c)
	return c:IsSetCard(0xad) and c:IsType(TYPE_MONSTER)
end
function c73240432.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73240432.damfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local val=Duel.GetMatchingGroupCount(c73240432.damfilter,tp,LOCATION_GRAVE,0,nil)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function c73240432.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local val=Duel.GetMatchingGroupCount(c73240432.damfilter,tp,LOCATION_GRAVE,0,nil)*200
	Duel.Damage(p,val,REASON_EFFECT)
end

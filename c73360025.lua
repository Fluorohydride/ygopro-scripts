--魔神王の契約書
function c73360025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=aux.AddFusionEffectProcUltimate(c,{
		mat_filter=aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),
		mat_location=LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,
		fcheck=c73360025.fcheck,
		reg=false
	})
	e2:SetDescription(aux.Stringid(73360025,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,73360025)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c73360025.damcon)
	e3:SetTarget(c73360025.damtg)
	e3:SetOperation(c73360025.damop)
	c:RegisterEffect(e3)
end
function c73360025.exfilter(c)
	return c:IsLocation(LOCATION_GRAVE)
end
function c73360025.fcheck(tp,sg,fc)
	if fc:IsSetCard(0xaf) then
		return true
	else
		return not sg:IsExists(c73360025.exfilter,1,nil)
	end
end
function c73360025.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c73360025.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end
function c73360025.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

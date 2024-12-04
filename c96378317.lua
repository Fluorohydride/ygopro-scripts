--鉄獣の邂逅
function c96378317.initial_effect(c)
	--(1) Gains ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96378317,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,96378317)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c96378317.target)
	e1:SetOperation(c96378317.activate)
	c:RegisterEffect(e1)
	--(2) Destroy Replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96378317,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,96378318)
	e2:SetValue(c96378317.replaceval)
	e2:SetTarget(c96378317.replacetg)
	e2:SetOperation(c96378317.replaceop)
	c:RegisterEffect(e2)
end
function c96378317.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsLinkState()
end
function c96378317.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsController(tp) and c96378317.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c96378317.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c96378317.atkfilter,tp,LOCATION_MZONE,0,1,99,nil)
end
function c96378317.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(700)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c96378317.replaceft(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsLinkState()
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c96378317.replacetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c96378317.replaceft,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c96378317.replaceval(e,c)
	return c96378317.replaceft(c,e:GetHandlerPlayer())
end
function c96378317.replaceop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end

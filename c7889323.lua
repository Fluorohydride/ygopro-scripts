--鉄獣の死線
---@param c Card
function c7889323.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7889323,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,7889323)
	e1:SetCondition(c7889323.thcon)
	e1:SetTarget(c7889323.thtg)
	e1:SetOperation(c7889323.thop)
	c:RegisterEffect(e1)
	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7889323,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,7889324)
	e2:SetCondition(c7889323.bacon)
	e2:SetTarget(c7889323.batg)
	e2:SetOperation(c7889323.baop)
	c:RegisterEffect(e2)
end
function c7889323.spfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsControler(tp)
end
function c7889323.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7889323.spfilter,1,nil,tp)
end
function c7889323.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x14d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c7889323.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c7889323.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7889323.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c7889323.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c7889323.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c7889323.bacon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if not ac:IsControler(tp) then ac,bc=bc,ac end
	e:SetLabelObject(bc)
	return ac:IsFaceup() and ac:IsControler(tp) and ac:IsSetCard(0x14d) and bc:IsControler(1-tp)
end
function c7889323.batg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if not bc then return false end
	if chk==0 then return bc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,bc,1,0,0)
end
function c7889323.baop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc and bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		Duel.SendtoHand(bc,nil,REASON_EFFECT)
	end
end

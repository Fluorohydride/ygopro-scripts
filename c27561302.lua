--雨の天気模様
--Prototype, might require a core update for full functionality
function c27561302.initial_effect(c)
	c:SetUniqueOnField(1,0,27561302)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c27561302.effop)
	c:RegisterEffect(e2)
end
function c27561302.efffilter(c,g,ignore_flag)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsSetCard(0x109)
		and c:GetSequence()<5 and g:IsContains(c) and (ignore_flag or c:GetFlagEffect(27561302)==0)
end
function c27561302.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup(1,1)
	local g=Duel.GetMatchingGroup(c27561302.efffilter,tp,LOCATION_MZONE,0,nil,cg)
	if c:IsDisabled() then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(27561302,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(27561302,0))
		e1:SetCategory(CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabelObject(c)
		e1:SetCost(aux.bfgcost)
		e1:SetTarget(c27561302.thtg)
		e1:SetOperation(c27561302.thop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c27561302.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c27561302.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c27561302.thfilter(chkc) end
	local gc=e:GetLabelObject()
	if chk==0 then return gc and gc:IsFaceup() and gc:IsLocation(LOCATION_SZONE)
		and not gc:IsDisabled() and c27561302.efffilter(e:GetHandler(),gc:GetColumnGroup(1,1),true)
		and Duel.IsExistingTarget(c27561302.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c27561302.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27561302.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

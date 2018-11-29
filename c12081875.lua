--轟雷機龍－サンダー・ドラゴン
function c12081875.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_THUNDER),2)
	--apply effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12081875,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12081875)
	e1:SetCondition(c12081875.effcon)
	e1:SetTarget(c12081875.efftg)
	e1:SetOperation(c12081875.effop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c12081875.reptg)
	e2:SetValue(c12081875.repval)
	c:RegisterEffect(e2)
end
function c12081875.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c12081875.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x11c) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())) then return false end
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local te=m.discard_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c12081875.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c12081875.efffilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(c12081875.efffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c12081875.efffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local m=_G["c"..tc:GetCode()]
	local te=m.discard_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c12081875.effop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local m=_G["c"..tc:GetCode()]
		local te=m.discard_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		Duel.BreakEffect()
		local opt=Duel.SelectOption(tp,aux.Stringid(12081875,1),aux.Stringid(12081875,2))
		if opt==0 then
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		else
			Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
		end
	end
end
function c12081875.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_THUNDER) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c12081875.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12081875.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,3,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,3,3,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	end
	return false
end
function c12081875.repval(e,c)
	return c12081875.repfilter(c,e:GetHandlerPlayer())
end

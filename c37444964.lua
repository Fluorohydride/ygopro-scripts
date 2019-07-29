--Dream Mirror Fantasy
function c37444964.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37444964+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c37444964.condition)
	e1:SetTarget(c37444964.target)
	e1:SetOperation(c37444964.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c37444964.reptg)
	e2:SetValue(c37444964.repval)
	e2:SetOperation(c37444964.repop)
	c:RegisterEffect(e2)
end
function c37444964.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x131)
end
function c37444964.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37444964.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c37444964.filter1(c)
	return c:IsFaceup() and c:IsCode(74665651) and c:IsAbleToDeck()
end
function c37444964.filter2(c)
	return c:IsFaceup() and c:IsCode(1050355) and c:IsAbleToDeck()
end
function c37444964.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c37444964.filter1,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingTarget(c37444964.filter2,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c37444964.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c37444964.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g3,1,0,0)
end
function c37444964.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
		if sg:GetCount()>0 then
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c37444964.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x131)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c37444964.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c37444964.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c37444964.repval(e,c)
	return c37444964.repfilter(c,e:GetHandlerPlayer())
end
function c37444964.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

--D-HERO デッドリーガイ
---@param c Card
function c30757127.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc008),c30757127.ffilter,true)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30757127,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,30757127)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c30757127.atkcost)
	e1:SetTarget(c30757127.atktg)
	e1:SetOperation(c30757127.atkop)
	c:RegisterEffect(e1)
end
c30757127.material_setcode=0xc008
function c30757127.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsFusionType(TYPE_EFFECT)
end
function c30757127.cfilter(c,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c30757127.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c)
end
function c30757127.tgfilter(c)
	return c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c30757127.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30757127.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.DiscardHand(tp,c30757127.cfilter,1,1,REASON_COST+REASON_DISCARD,nil,tp)
end
function c30757127.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c30757127.atkfilter(c)
	return c:IsSetCard(0xc008) and c:IsFaceup()
end
function c30757127.ctfilter(c)
	return c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER)
end
function c30757127.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c30757127.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local tg=Duel.GetMatchingGroup(c30757127.atkfilter,tp,LOCATION_MZONE,0,nil)
		if tg:GetCount()<=0 then return end
		local ct=Duel.GetMatchingGroupCount(c30757127.ctfilter,tp,LOCATION_GRAVE,0,nil)
		local tc=tg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*200)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=tg:GetNext()
		end
	end
end

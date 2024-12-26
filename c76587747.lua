--クロノダイバー・レトログラード
---@param c Card
function c76587747.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,76587747+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c76587747.condition)
	e1:SetTarget(c76587747.target)
	e1:SetOperation(c76587747.activate)
	c:RegisterEffect(e1)
end
function c76587747.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x126) and c:IsType(TYPE_XYZ)
end
function c76587747.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x126) and c:IsType(TYPE_XYZ) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c76587747.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c76587747.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsChainNegatable(ev)
end
function c76587747.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c76587747.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c76587747.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 and not g:GetFirst():IsImmuneToEffect(e) and rc:IsCanOverlay() then
			rc:CancelToGrave()
			Duel.Overlay(g:GetFirst(),Group.FromCards(rc))
		end
	end
end

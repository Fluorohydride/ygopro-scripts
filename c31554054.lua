--エクシーズ・リベンジ・シャッフル
---@param c Card
function c31554054.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c31554054.condition)
	e1:SetTarget(c31554054.target)
	e1:SetOperation(c31554054.activate)
	c:RegisterEffect(e1)
end
function c31554054.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at and at:IsFaceup() and at:IsControler(tp) and at:IsType(TYPE_XYZ)
end
function c31554054.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c31554054.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c31554054.filter(chkc,e,tp) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler():IsCanOverlay()
		and Duel.GetAttackTarget():IsAbleToDeck() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c31554054.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c31554054.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.GetAttackTarget():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,Duel.GetAttackTarget(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c31554054.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttackTarget()
	if at:IsRelateToEffect(e) and at:IsFaceup() and Duel.SendtoDeck(at,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end

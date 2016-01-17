--ダイナミスト・エラプション
function c74582050.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DELAYED_QUICKEFFECT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c74582050.target)
	e1:SetOperation(c74582050.activate)
	c:RegisterEffect(e1)
end
function c74582050.xfilter(c,tp)
	return c:IsFaceup() and (c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd8) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)))
end
function c74582050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c74582050.xfilter,1,nil,tp) and Duel.IsExistingTarget(Duel.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Duel.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,nil,1,0)
end
function c74582050.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end
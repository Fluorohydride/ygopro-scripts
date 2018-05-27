--十二獣ドランシア
function c48905153.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,4,c48905153.ovfilter,aux.Stringid(48905153,0),4,c48905153.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c48905153.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c48905153.defval)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(48905153,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c48905153.descost)
	e3:SetTarget(c48905153.destg)
	e3:SetOperation(c48905153.desop)
	c:RegisterEffect(e3)
end
function c48905153.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(48905153)
end
function c48905153.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,48905153)==0 end
	Duel.RegisterFlagEffect(tp,48905153,RESET_PHASE+PHASE_END,0,1)
end
function c48905153.atkfilter(c)
	return c:IsSetCard(0xf1) and c:GetAttack()>=0
end
function c48905153.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c48905153.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c48905153.deffilter(c)
	return c:IsSetCard(0xf1) and c:GetDefense()>=0
end
function c48905153.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c48905153.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c48905153.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c48905153.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c48905153.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

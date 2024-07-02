--Ashened For Eternity
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--get control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.contrtg)
	e2:SetOperation(s.controp)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return (c:IsCode(78783557) or c:IsSetCard(0x1ad) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.contrfilter(c,tp)
	return c:GetOwner()==tp and c:IsControlerCanBeChanged()
end
function s.contrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.contrfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.contrfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,s.contrfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function s.controp(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and Duel.GetControl(tc,tp) and tc:IsLocation(LOCATION_MZONE) and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		for ac in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-tc:GetBaseAttack())
			ac:RegisterEffect(e1)
		end
	end
end
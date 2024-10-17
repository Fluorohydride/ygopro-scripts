--コンドーレンス・パペット
---@param c Card
function c57093995.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(57093995,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,57093995)
	e1:SetTarget(c57093995.target)
	e1:SetOperation(c57093995.activate)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(57093995,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,57093996)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c57093995.indtg)
	e2:SetOperation(c57093995.indop)
	c:RegisterEffect(e2)
end
function c57093995.tgfilter(c)
	return c:IsSetCard(0x1083) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c57093995.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57093995.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c57093995.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c57093995.tgfilter,tp,LOCATION_DECK,0,nil)
	local ct=Duel.GetMatchingGroupCount(Card.IsSummonLocation,tp,0,LOCATION_MZONE,nil,LOCATION_EXTRA)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct+1)
	if sg and sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c57093995.indfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE)
end
function c57093995.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c57093995.indfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c57093995.indfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c57093995.indfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c57093995.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(aux.indoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

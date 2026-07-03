--アメイズメント・プレシャスパーク
function c33773528.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Trap activate in set turn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33773528,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCountLimit(1,33773528)
	e1:SetCondition(c33773528.actcon)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15c))
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33773528,0))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,33773529)
	e2:SetCost(c33773528.cost)
	e2:SetTarget(c33773528.target)
	e2:SetOperation(c33773528.activate)
	c:RegisterEffect(e2)
end
function c33773528.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c33773528.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x15c) and c:IsType(TYPE_TRAP) and c:GetEquipTarget() and c:IsAbleToGraveAsCost() and Duel.GetSZoneCount(tp,c)>0
		and Duel.IsExistingTarget(c33773528.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c:GetCode())
end
function c33773528.setfilter(c,code)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x15c) and c:IsType(TYPE_TRAP) and not c:IsCode(code) and c:IsSSetable(true)
end
function c33773528.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c33773528.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c33773528.setfilter(chkc,e:GetLabel()) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c33773528.filter,tp,LOCATION_SZONE,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33773528.filter,tp,LOCATION_SZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local code=g:GetFirst():GetCode()
	e:SetLabel(code)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectTarget(tp,c33773528.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,code)
	if sg:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,1,0,0)
	end
end
function c33773528.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
	end
end

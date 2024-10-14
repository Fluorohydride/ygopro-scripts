--マジェスティ・ヒュペリオン
---@param c Card
function c91434602.initial_effect(c)
	aux.AddCodeList(c,56433456)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,91434602+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c91434602.hspcon)
	e1:SetTarget(c91434602.hsptg)
	e1:SetOperation(c91434602.hspop)
	c:RegisterEffect(e1)
	--reflect damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ALSO_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY))
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(91434602,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c91434602.rmcon)
	e3:SetCost(c91434602.rmcost)
	e3:SetTarget(c91434602.rmtg)
	e3:SetOperation(c91434602.rmop)
	c:RegisterEffect(e3)
end
function c91434602.spcfilter(c,tp)
	return c:IsSetCard(0x44) and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
		and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c91434602.hspcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c91434602.spcfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
end
function c91434602.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c91434602.spcfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c91434602.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
end
function c91434602.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsEnvironment(56433456,PLAYER_ALL,LOCATION_ONFIELD+LOCATION_GRAVE)
	if check then return e:GetHandler():GetFlagEffect(91434602)<2
	else return e:GetHandler():GetFlagEffect(91434602)<1 end
end
function c91434602.costfilter(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c)
end
function c91434602.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91434602.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c91434602.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c91434602.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(91434602,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c91434602.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

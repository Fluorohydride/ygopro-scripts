--幻煌龍の戦禍
function c34302287.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c34302287.condition)
	e1:SetTarget(c34302287.target)
	e1:SetOperation(c34302287.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c34302287.handcon)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34302287,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c34302287.eqcost)
	e3:SetTarget(c34302287.eqtg)
	e3:SetOperation(c34302287.eqop)
	c:RegisterEffect(e3)
end
function c34302287.cfilter(c)
	return c:IsFacedown() or not c:IsType(TYPE_NORMAL)
end
function c34302287.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c34302287.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c34302287.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c34302287.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c34302287.filter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c34302287.handcon(e)
	return Duel.IsExistingMatchingCard(c34302287.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end
function c34302287.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c34302287.efilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsCanBeEffectTarget(e)
end
function c34302287.eqfilter(c,g)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsSetCard(0xfa) and g:IsExists(c34302287.eqcheck,1,nil,c)
end
function c34302287.eqcheck(c,ec)
	return ec:CheckEquipTarget(c)
end
function c34302287.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c34302287.efilter,tp,LOCATION_MZONE,0,nil,e)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c34302287.efilter(chkc,e) end
	if chk==0 then return g:GetCount()>0 and Duel.IsExistingMatchingCard(c34302287.eqfilter,tp,LOCATION_SZONE,0,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c34302287.efilter,tp,LOCATION_MZONE,0,1,1,nil,e)
end
function c34302287.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c34302287.eqfilter,tp,LOCATION_SZONE,0,nil,tg)
	local eq=g:GetFirst()
	while eq do
		Duel.Equip(tp,eq,tc,true,true)
		eq=g:GetNext()
	end
	Duel.EquipComplete()
end

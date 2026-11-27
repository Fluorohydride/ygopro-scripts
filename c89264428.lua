--ベアルクティ・ビッグディッパー
function c89264428.initial_effect(c)
	c:EnableCounterPermit(0x5b)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(89264428)
	e2:SetCountLimit(1)
	e2:SetTarget(c89264428.repfilter)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c89264428.ctop)
	c:RegisterEffect(e3)
	--take control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(89264428,0))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c89264428.tkccon)
	e4:SetCost(c89264428.tkccost)
	e4:SetTarget(c89264428.tkctg)
	e4:SetOperation(c89264428.tkcop)
	c:RegisterEffect(e4)
end
function c89264428.repfilter(e,c)
	return c:IsLevelAbove(7) and c:IsSetCard(0x163)
end
function c89264428.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x5b,1)
end
function c89264428.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x163) and c:IsType(TYPE_SYNCHRO)
end
function c89264428.tkccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c89264428.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c89264428.tkccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x5b,7,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x5b,e:GetHandler():GetCounter(0x5b),REASON_COST)
end
function c89264428.tkctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
		and c89264428.tkccon(e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c89264428.tkcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end

--白銀の城の狂時計
function c2511.initial_effect(c)
	--Trap activate in set turn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2511,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,2511)
	e1:SetCost(c2511.cost)
	e1:SetOperation(c2511.operation)
	c:RegisterEffect(e1)
	--to hand or spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2511,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,2512)
	e2:SetCondition(c2511.tscon)
	e2:SetTarget(c2511.tstg)
	e2:SetOperation(c2511.tsop)
	c:RegisterEffect(e2)
end
function c2511.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c2511.filter(c)
	return c:IsSetCard(0x17e) and c:IsFaceup()
end
function c2511.actcon(e)
	return Duel.IsExistingMatchingCard(c2511.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c2511.acttg(e,c)
	return c:GetType()==TYPE_TRAP
end
function c2511.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(2511,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCountLimit(1)
	e1:SetCondition(c2511.actcon)
	e1:SetTarget(c2511.acttg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c2511.tscon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rp==tp and r&REASON_COST>0
		and (rc:IsSetCard(0x17e) and not rc:IsCode(2511) or re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:GetType()==TYPE_TRAP)
		and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) and not eg:IsContains(e:GetHandler())
end
function c2511.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) end
end
function c2511.tsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if aux.NecroValleyNegateCheck(c) then return end
	if not aux.NecroValleyFilter()(c) then return end
	local b1=c:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local op=aux.SelectFromOptions(tp,{b1,1190},{b2,1152})
	if op==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	if op==2 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

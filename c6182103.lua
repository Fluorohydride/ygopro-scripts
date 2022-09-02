--究極体ミュートリアス
function c6182103.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c6182103.ffilter,3,true)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6182103,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,6182103)
	e1:SetCondition(c6182103.negcon)
	e1:SetCost(c6182103.negcost)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(c6182103.negop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79194594,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,6182104)
	e2:SetCondition(c6182103.thcon)
	e2:SetTarget(c6182103.thtg)
	e2:SetOperation(c6182103.thop)
	c:RegisterEffect(e2)
end
function c6182103.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x157) and c:IsLevelAbove(8)
end
function c6182103.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end
function c6182103.cfilter(c,rtype)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsAbleToRemoveAsCost()
		and (not c:IsOnField() or c:IsFaceup())
		and c:IsType(rtype) and c:IsSetCard(0x157)
end
function c6182103.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=re:GetActiveType()&0x7
	if chk==0 then return Duel.IsExistingMatchingCard(c6182103.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,rtype) end
	local g=Duel.SelectMatchingCard(tp,c6182103.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,rtype)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c6182103.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c6182103.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c6182103.thfilter(c,typ)
	return c:IsAbleToHand() and c:IsSetCard(0x157) and c:IsFaceup()
end
function c6182103.gcheck(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c6182103.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6182103.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c6182103.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6182103.thfilter,tp,LOCATION_REMOVED,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,c6182103.gcheck,false,1,3)
		if sg then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end

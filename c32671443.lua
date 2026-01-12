--ドクターD
function c32671443.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32671443,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c32671443.cost)
	e1:SetTarget(c32671443.target)
	e1:SetOperation(c32671443.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32671443,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c32671443.atktg)
	e2:SetOperation(c32671443.atkop)
	c:RegisterEffect(e2)
end
function c32671443.costfilter(c,e,tp)
	return c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c32671443.thfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c32671443.thfilter(c,e,tp)
	if not (c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c32671443.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32671443.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c32671443.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c32671443.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		or Duel.IsExistingMatchingCard(c32671443.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c32671443.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c32671443.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand()
			and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c32671443.atkfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc008)
		and Duel.IsExistingTarget(c32671443.atkfilter2,tp,LOCATION_MZONE,0,1,c,c)
end
function c32671443.atkfilter2(c,tc)
	return c:IsFaceup() and c:IsSetCard(0xc008) and not c:IsAttack(tc:GetAttack())
end
function c32671443.tgfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0xc008) and c:IsCanBeEffectTarget(e)
end
function c32671443.gcheck(g)
	return g:GetFirst():GetAttack()~=g:GetNext():GetAttack()
end
function c32671443.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c32671443.atkfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c32671443.tgfilter,tp,LOCATION_MZONE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,c32671443.gcheck,false,2,2)
	Duel.SetTargetCard(tg)
end
function c32671443.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:FilterCount(Card.IsFaceup,nil)<2 then return end
	if g:GetFirst():GetAttack()==g:GetNext():GetAttack() then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(32671443,2))
	local tc2=g:Select(tp,1,1,nil):GetFirst()
	local tc1=(g-tc2):GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(tc1:GetAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc2:RegisterEffect(e1)
end
